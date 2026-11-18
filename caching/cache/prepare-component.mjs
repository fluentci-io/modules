import { build } from "esbuild";
import { gzipSync } from "node:zlib";
import { mkdir, writeFile } from "node:fs/promises";
import { resolve } from "node:path";

export async function prepareComponent(root) {
  await mkdir(resolve(root, "dist"), { recursive: true });
  const result = await build({
    absWorkingDir: root,
    entryPoints: ["host.mjs"],
    bundle: true,
    minify: true,
    write: false,
    platform: "node",
    format: "esm",
    target: "node24",
    external: ["node:*"],
    banner: {
      js: "import {createRequire} from 'node:module';const require=createRequire(process.cwd()+'/fluentci-cache-host.cjs');",
    },
  });
  const host = result.outputFiles[0].text;
  await writeFile(resolve(root, "dist/cache-host.mjs"), host);
  await writeFile(
    resolve(root, "dist/embedded-host.mjs"),
    `export const hostProgram=${JSON.stringify(gzipSync(host).toString("base64"))};\n`,
  );
}
