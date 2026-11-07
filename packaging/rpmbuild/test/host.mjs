import { spawnSync } from "node:child_process";

export function fixture(options = {}) {
  const calls = [];
  const output = [];
  let pending = [];
  function command(args) {
    calls.push(args);
    if (options.fail?.(args)) throw new Error("Injected command failure: " + args[0]);
    if (options.native) {
      const result = spawnSync(args[0], args.slice(1), { encoding: "utf8" });
      if (result.error) throw result.error;
      if (result.status !== 0) throw new Error(`${args[0]} failed: ${result.stdout}\n${result.stderr}`);
      return result.stdout;
    }
    if (args[0] === "realpath") return args.at(-1);
    if (args[0] === "dirname") return args.at(-1).replace(/\/[^/]*$/, "");
    if (args[0] === "cat") return options.control ?? "Package: custom-tool\nVersion: 2.3.0\nArchitecture: arm64\nMaintainer: Example <example@example.org>\nDescription: A custom package\n";
    if (args[0] === "dpkg-deb" && args.includes("--field")) return options.builtArch ?? "arm64";
    if (args[0] === "rpmspec" && args.includes("--query")) return options.metadata ?? "aarch64\tcustom-tool-2.3.0-1.aarch64.rpm\n";
    if (args[0] === "rpm" && args.includes("--query")) return options.builtArch ?? "aarch64";
    return "";
  }
  globalThis.Memory = {
    fromString: value => ({ offset: value }),
    find: value => ({ readString: () => value }),
  };
  globalThis.Host = {
    inputString: () => typeof options.input === "string" ? options.input : JSON.stringify(options.input ?? {}),
    outputString: value => output.push(value),
    getFunctions: () => new Proxy({}, {
      get: (_target, name) => value => {
        if (name === "get_os") return options.os ?? "linux";
        if (name === "pipeline") { pending = []; return JSON.stringify({ id: "fixture" }); }
        if (name === "with_exec") {
          pending.push(JSON.parse(value).map(arg => {
            if (!arg.startsWith("'") || !arg.endsWith("'")) throw new Error("Expected literal argv");
            return arg.slice(1, -1).replaceAll("'\\''", "'");
          }));
        }
        if (name === "stdout") return pending.map(command).join("");
        return "";
      },
    }),
  };
  return { calls, output };
}
