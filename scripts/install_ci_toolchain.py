#!/usr/bin/env python3
"""Install the pinned CI toolchain under a disposable/cache directory."""
import argparse
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def install(directory):
    directory = Path(directory).resolve()
    npm = directory / "npm"
    npm.mkdir(parents=True, exist_ok=True)
    for name in ["package.json", "package-lock.json"]:
        shutil.copyfile(ROOT / ".github/toolchain" / name, npm / name)
    subprocess.run(["npm", "ci", "--no-audit", "--no-fund"], cwd=npm, check=True)
    return [directory / "npm/node_modules/.bin"]



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", type=Path, required=True)
    args = parser.parse_args()
    paths = install(args.directory)
    print("Toolchain ready. Add to PATH: " + ":".join(map(str, paths)))
