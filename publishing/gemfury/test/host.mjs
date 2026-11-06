// Stub host for compiled PureScript; never reads real publishing credentials.
import { spawnSync } from "node:child_process";

export function fixture(env = {}, options = {}) {
  const calls = [];
  const output = [];
  let pending = [];
  const command = (args) => {
    calls.push(args);
    if (options.fail?.(args)) throw new Error("Injected command failure");
    if (options.nativePreflight && args[0] === "test") {
      const result = spawnSync(args[0], args.slice(1), { encoding: "utf8" });
      if (result.error) throw result.error;
      if (result.status !== 0) throw new Error("Package preflight failed");
    }
    return "";
  };
  globalThis.Memory = {
    fromString: (value) => ({ offset: value }),
    find: (value) => ({ readString: () => value }),
  };
  globalThis.Host = {
    inputString: () => options.input ?? "",
    outputString: (value) => output.push(value),
    getFunctions: () => new Proxy({}, {
      get: (_target, name) => (value) => {
        if (name === "has_env") return JSON.stringify(Object.hasOwn(env, value));
        if (name === "get_env") return env[value];
        if (name === "pipeline") {
          pending = [];
          return JSON.stringify({ id: "fixture" });
        }
        if (name === "with_exec") {
          const args = JSON.parse(value).map((arg) => {
            if (!arg.startsWith("'") || !arg.endsWith("'")) throw new Error("Expected literal argv");
            return arg.slice(1, -1).replaceAll("'\\''", "'");
          });
          pending.push(args);
        }
        if (name === "stdout") return pending.map(command).join("");
        return "";
      },
    }),
  };
  return { calls, output };
}
