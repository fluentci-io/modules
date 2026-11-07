#!/usr/bin/env python3
"""Install the pinned CI toolchain under a disposable/cache directory."""
import argparse
import gzip
import hashlib
import json
from pathlib import Path
import platform
import shutil
import subprocess
import tarfile
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def install(directory):
    os_name = {"Linux": "linux", "Darwin": "macos"}[platform.system()]
    arch = {"x86_64": "x86_64", "AMD64": "x86_64", "arm64": "aarch64", "aarch64": "aarch64"}[platform.machine()]
    releases = json.loads((ROOT / ".github/toolchain/releases.json").read_text())
    directory = Path(directory).resolve()
    npm = directory / "npm"
    npm.mkdir(parents=True, exist_ok=True)
    for name in ["package.json", "package-lock.json"]:
        shutil.copyfile(ROOT / ".github/toolchain" / name, npm / name)
    subprocess.run(["npm", "ci", "--no-audit", "--no-fund"], cwd=npm, check=True)
    with tempfile.TemporaryDirectory(prefix="fluentci-ci-tools-") as temporary:
        temporary = Path(temporary)
        for name, release in releases.items():
            asset = release["assets"][f"{os_name}-{arch}"]
            archive = temporary / (name + ".archive")
            subprocess.run(["curl", "--fail", "--location", "--silent", "--show-error", "--retry", "3", "--connect-timeout", "30", "--max-time", "300", "--output", str(archive), asset["url"]], check=True)
            with archive.open("rb") as downloaded:
                digest = hashlib.file_digest(downloaded, "sha256").hexdigest()
            if digest != asset["sha256"]:
                raise ValueError(f"SHA-256 mismatch for {name}")
            if name == "extism-js":
                target = directory / "bin/extism-js"
                target.parent.mkdir(parents=True, exist_ok=True)
                with gzip.open(archive, "rb") as source, target.open("wb") as output:
                    shutil.copyfileobj(source, output)
                target.chmod(0o755)
            else:
                unpack = temporary / "binaryen"
                with tarfile.open(archive) as source:
                    source.extractall(unpack, filter="data")
                shutil.copytree(unpack / ("binaryen-" + release["tag"]), directory / "binaryen", dirs_exist_ok=True)
    return [directory / "bin", directory / "npm/node_modules/.bin", directory / "binaryen/bin"]


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", type=Path, required=True)
    args = parser.parse_args()
    paths = install(args.directory)
    print("Toolchain ready. Add to PATH: " + ":".join(map(str, paths)))
