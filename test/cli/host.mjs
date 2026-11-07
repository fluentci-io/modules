import { spawnSync } from "node:child_process";
import { existsSync, mkdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";

// Minimal host that can execute plans locally without cloud credentials.
export function fixture(options = {}) {
  const calls = [], plans = [], output = [];
  const environment = { UBI_TOKEN: "fixture-token", ...options.env };
  let pending = [];
  function command(args) {
    calls.push(args);
    if (options.fail?.(args)) throw Error("Injected command failure: " + args[0]);
    if (options.native) {
      const result = spawnSync(args[0], args.slice(1), { encoding: "utf8" });
      if (result.error) throw result.error;
      if (result.status !== 0) throw Error(`${args[0]} failed: ${result.stderr}`);
      return result.stdout;
    }
    return args[0] === "cat" ? JSON.stringify({ tasks: [], outcome: "succeeded" }) : "";
  }
  globalThis.Memory = { fromString: value => ({ offset: value }), find: value => ({ readString: () => value }) };
  globalThis.Host = {
    inputString: () => typeof options.input === "string" ? options.input : JSON.stringify(options.input ?? {}),
    outputString: value => output.push(value),
    getFunctions: () => new Proxy({}, { get: (_target, name) => value => {
      if (name === "get_os") return options.os ?? "linux";
      if (name === "get_env") return environment[value] ?? "";
      if (name === "has_env") return JSON.stringify(Object.hasOwn(environment, value));
      if (name === "execute_plan") {
        const request = JSON.parse(value);
        plans.push(request);
        if (options.transportError) throw Error("Injected transport error");
        if (options.response !== undefined) return options.response;
        let report = { tasks: [], outcome: options.outcome ?? "succeeded" };
        if (options.native) {
          if (existsSync(request.run_dir)) throw Error("Run directory already exists");
          mkdirSync(request.run_dir, { recursive: true });
          for (const task of request.plan.tasks) {
            const result = spawnSync(task.program, task.args, {
              cwd: task.cwd, env: { ...process.env, ...environment, ...task.env }, encoding: "utf8", timeout: task.timeout_ms,
            });
            if (result.error) throw result.error;
            writeFileSync(join(request.run_dir, task.id + '.stdout'), result.stdout);
            writeFileSync(join(request.run_dir, task.id + '.stderr'), result.stderr);
            if (result.status !== 0) report.outcome = "failed";
          }
          writeFileSync(join(request.run_dir, 'result.json'), JSON.stringify(report));
        }
        return JSON.stringify(report);
      }
      if (name === "pipeline") { pending = []; return JSON.stringify({ id: "cli-fixture" }); }
      if (name === "with_exec") {
        pending.push(JSON.parse(value).map(arg => {
          if (!arg.startsWith("'") || !arg.endsWith("'")) throw Error("Expected literal argv");
          return arg.slice(1, -1).replaceAll("'\\''", "'");
        }));
      }
      if (name === "stdout") return pending.map(command).join("");
      return "";
    } }),
  };
  return { calls, plans, output };
}
