import { spawnSync } from "node:child_process";
import { copyFileSync, readFileSync } from "node:fs";
import { createHash } from "node:crypto";

export const versions = { pkl: "0.33.0", bun: "1.2.3", deno: "2.1.0", elixir: "1.18.0", gleam: "1.9.1", go: "1.24.0", java: "21.0.5", node: "22.14.0", rust: "1.85.0", zig: "0.14.0", purescript: "0.15.16", nix: "2.26.0", "determinate-nix": "3.2.0" };
export function versionText(tool, version = versions[tool]) {
  if (tool === "go") return `go version go${version} linux/amd64\n`;
  if (tool === "java") return `openjdk version "${version}" 2025-01-01\n`;
  if (tool === "elixir") return `Erlang/OTP 27 [erts-15]\nElixir ${version} (compiled with Erlang/OTP 27)\n`;
  if (tool === "determinate-nix") return `nix (Determinate Nix ${version}) 2.28.0\n`;
  return `${tool === "rust" ? "rustc" : tool} ${version}\n`;
}
export function fixture(tool, options = {}) {
  const calls = [], output = [], updates = [];
  const environment = { HOME: "/home/test", PATH: "/usr/bin:/bin", TMPDIR: "/tmp", ...options.env };
  let pending = [];
  const platform = (options.os ?? "linux") === "darwin" ? "macos" : options.os ?? "linux";
  const architecture = options.arch ?? "x86_64";
  const normalizedArchitecture = ["amd64", "x64"].includes(architecture) ? "x86_64" : architecture === "arm64" ? "aarch64" : architecture;
  function metadata(url) {
    if (options.responses?.[url] !== undefined) return options.responses[url];
    if (url.includes("api.github.com") && tool === "pkl") return JSON.stringify({tag_name: versions.pkl});
    if (url.includes("api.github.com")) return JSON.stringify({ tag_name: url.includes("oven-sh/bun") ? `bun-v${versions.bun}` : `v${versions[tool]}` });
    if (url.includes("nodejs.org/dist/index.json")) return JSON.stringify([{ version: `v${versions.node}`, lts: "Jod" }]);
    if (url.includes("go.dev/VERSION")) return `go${versions.go}\ntime 2025-01-01`;
    if (url.includes("available_releases")) return JSON.stringify({ most_recent_lts: 21 });
    if (url.includes("ziglang.org/download/index.json")) {
      const entry = { tarball: "https://ziglang.org/download/fixture.tar.xz", shasum: options.digest ?? "a".repeat(64) };
      return JSON.stringify({ master: {}, [versions.zig]: { [`${normalizedArchitecture}-${platform}`]: entry } });
    }
    throw Error("Unexpected metadata URL: " + url);
  }
  function command(args, stderr) {
    calls.push(args);
    if (options.command) { const result = options.command(args, stderr); if (result !== undefined) return result; }
    if (options.fail?.(args)) throw Error("Injected command failure: " + args.join(" "));
    if (tool === "pkl" && args[0] === "java" && args[1] === "-version") return 'openjdk version "21.0.5"\n';
    if (tool === "zig" && args[1] === "--version") throw Error("Zig uses the version subcommand");
    if (args[0] === "curl" && !options.network) {
      if (args.includes("--output")) {
        if (options.native) copyFileSync(options.artifact, args[args.indexOf("--output") + 1]);
        return "";
      }
      return metadata(args.at(-1));
    }
    if (options.fakeErlang && args[0] === "which" && args[1] === "erl") return "/fixture/erl";
    if (options.fakeErlang && args[0] === "erl") return "27";
    if (options.native) {
      const result = spawnSync(args[0], args.slice(1), { encoding: "utf8", env: { ...process.env, ...environment } });
      if (result.error) throw result.error;
      if (result.status !== 0) throw Error(`${args[0]} failed: ${result.stdout}\n${result.stderr}`);
      return stderr ? result.stderr : result.stdout;
    }
    if (args[0] === "test" && args[1] === "-e") {
      if (!options.existing || args[2] === "/etc/alpine-release") throw Error("not found");
      return "";
    }
    if (args[0] === "mktemp") return args.at(-1).replace("XXXXXXXX", "fixture");
    if (args[0] === "dirname") return args[1].slice(0, args[1].lastIndexOf("/")) || "/";
    if (args[0] === "erl") return options.otp ?? "27";
    if (args[0] === "pkg_info" && args.includes("-e")) return "jdk-21.0.5\n";
    if ((args[0] === "pkg" && args[1] === "info") || args[0] === "pkg_info") {
      if (options.listing !== undefined) return options.listing;
      if (tool === "java") return "/usr/local/openjdk21/bin/java\n";
      const prefix = platform === "netbsd" ? "/usr/pkg" : "/usr/local";
      return `${prefix}/bin/${tool === "rust" ? "rustc" : tool}\n` + (tool === "rust" ? `${prefix}/bin/cargo\n` : "");
    }
    if (args.includes("GOROOT")) return "/usr/local/go";
    if (args[0] === "/nix/nix-installer") return "nix-installer " + (options.installerVersion ?? "3.24.2");
    if (args.includes("--version") || args.includes("-version") || args[1] === "version") return options.versionOutput ?? versionText(tool, options.actualVersion);
    return "";
  }
  globalThis.Memory = { fromString: value => ({ offset: value }), find: value => ({ readString: () => value }) };
  globalThis.Host = {
    inputString: () => typeof options.input === "string" ? options.input : JSON.stringify(options.input ?? {}),
    outputString: value => output.push(value),
    getFunctions: () => new Proxy({}, { get: (_target, name) => value => {
      if (name === "get_os") return options.os ?? "linux";
      if (name === "get_arch") return architecture;
      if (name === "get_env") return environment[value] ?? "";
      if (name === "has_env") return JSON.stringify(Object.hasOwn(environment, value));
      if (name === "pipeline") { pending = []; return JSON.stringify({ id: "setup-fixture" }); }
      if (name === "set_envs") {
        const pairs = JSON.parse(value);
        updates.push(pairs);
        for (const [key, data] of pairs) environment[key] = data;
        return "";
      }
      if (name === "with_exec") {
        pending.push(JSON.parse(value).map(arg => {
          if (!arg.startsWith("'") || !arg.endsWith("'")) throw Error("Expected literal argv");
          return arg.slice(1, -1).replaceAll("'\\''", "'");
        }));
      }
      if (name === "stdout" || name === "stderr") return pending.map(args => command(args, name === "stderr")).join("");
      if (name === "file") return JSON.stringify({ id: "file-fixture" });
      if (name === "sha256") return options.native ? createHash("sha256").update(readFileSync(value)).digest("hex") : options.actualDigest ?? "a".repeat(64);
      return "";
    } }),
  };
  return { calls, output, environment, updates };
}
