#!/usr/bin/env python3
"""Validate the module registry and emit the GitHub Actions build matrix."""
import argparse
import json
import os
from pathlib import Path
import re
import sys
import tomllib

ROOT = Path(__file__).resolve().parents[1]


def entry_points(directory):
    text = (directory / "entry.mjs").read_text()
    match = re.fullmatch(r'\s*export\s*\{([^}]+)\}\s*from\s*[\'\"][^\'\"]+[\'\"];?\s*', text)
    if not match:
        raise ValueError(f"{directory}: entry.mjs must declare named re-exports")
    names = [name.strip() for name in match[1].split(",") if name.strip()]
    if len(names) != len(set(names)) or not all(re.fullmatch(r"[a-z][a-zA-Z0-9_]*", name) for name in names):
        raise ValueError(f"{directory}: invalid or duplicate entry points")
    source = (directory / "src/CI/Component.purs").read_text()
    public = re.search(r"module CI\.Component \(([^)]+)\) where", source)
    if public and sorted(n.strip() for n in public[1].split(",")) != sorted(names):
        raise ValueError(f"{directory}: entry points and PureScript exports differ")
    declared = [n for n in re.findall(r"^(\w+) :: .* -> Effect ", source, re.M) if n in names]
    if sorted(declared) != sorted(names):
        raise ValueError(f"{directory}: entry points and typed PureScript declarations differ")
    schema = json.loads((directory / "schema.json").read_text())
    if schema.get("runtime") != "component" or sorted(schema.get("exports", {})) != sorted(names):
        raise ValueError(f"{directory}: typed component schema differs from entry points")
    return names


def validate(root=ROOT):
    root = Path(root).resolve()
    modules = tomllib.loads((root / "fluentci.toml").read_text()).get("modules", [])
    if not modules:
        raise ValueError("fluentci.toml contains no modules")
    names = [module.get("name", "") for module in modules]
    if names != sorted(set(names)):
        raise ValueError("Module names must be unique and sorted alphabetically")
    paths = [module.get("path", "") for module in modules]
    if len(paths) != len(set(paths)):
        raise ValueError("Module paths must be unique")
    found = {str(path.parent.relative_to(root)) for path in root.glob("*/*/entry.mjs")}
    directories = {str(path.relative_to(root))
                   for category in {path.split('/')[0] for path in paths}
                   for path in (root / category).iterdir()
                   if path.is_dir() and not path.name.startswith('.')}
    if directories - set(paths):
        raise ValueError(f"Registry/source mismatch: unregistered={sorted(directories-set(paths))}")
    if set(paths) != found:
        raise ValueError(f"Registry/source mismatch: unregistered={sorted(found-set(paths))}, missing={sorted(set(paths)-found)}")
    license_text = (root / "LICENSE").read_text()
    if not license_text.startswith("MIT License\n"):
        raise ValueError("The root LICENSE must be MIT")
    result = []
    for module in modules:
        name, path = module["name"], module["path"]
        if not re.fullmatch(r"[a-z][a-z0-9-]*", name):
            raise ValueError(f"Invalid module name: {name}")
        if not re.fullmatch(r"[a-z][a-z0-9-]*/[a-z][a-z0-9-]*", path):
            raise ValueError(f"Invalid module path: {path}")
        if module.get("runtime") != "component":
            raise ValueError(f"{name}: native component runtime is required")
        if module.get("sdk") != "purescript":
            raise ValueError(f"{name}: unsupported SDK")
        if not re.fullmatch(r"\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?", module.get("version", "")):
            raise ValueError(f"{name}: invalid module version")
        directory = root / path
        if not directory.resolve().is_relative_to(root):
            raise ValueError(f"{name}: directory escapes the repository")
        for file in ["README.md", "LICENSE", "package.json", "package-lock.json", "spago.yaml", "spago.lock", "build.mjs", "entry.mjs", "schema.json", ".gitignore"]:
            if not (directory / file).is_file():
                raise ValueError(f"{name}: missing {file}")
        if (directory / "LICENSE").read_text() != license_text:
            raise ValueError(f"{name}: license differs from the root MIT license")
        if not (directory / "README.md").read_text().startswith("# "):
            raise ValueError(f"{name}: README has no title")
        if not list((directory / "src").rglob("*.purs")):
            raise ValueError(f"{name}: no PureScript source")
        if not list(directory.glob("test*.mjs")) and not list((directory / "test").glob("*.test.mjs")):
            raise ValueError(f"{name}: no test suite")
        package = json.loads((directory / "package.json").read_text())
        lock = json.loads((directory / "package-lock.json").read_text())
        json.loads((directory / "spago.lock").read_text())
        locked = lock["packages"][""]
        if package.get("license") != "MIT" or locked.get("license") != "MIT":
            raise ValueError(f"{name}: npm metadata must declare MIT")
        if package.get("name") != lock.get("name") or package.get("name") != locked.get("name"):
            raise ValueError(f"{name}: npm package and lockfile names differ")
        for kind in ["dependencies", "devDependencies", "optionalDependencies"]:
            if package.get(kind, {}) != locked.get(kind, {}):
                raise ValueError(f"{name}: npm {kind} differs from lockfile")
        if not all(package.get("scripts", {}).get(script) for script in ["build", "test"]):
            raise ValueError(f"{name}: npm build and test scripts are required")
        entry_points(directory)
        result.append({"name": name, "path": path})
    return result



def batches(modules, shards=4):
    """Cover every module once per OS while bounding runner count."""
    if shards < 1:
        raise ValueError("shards must be positive")
    buckets = [[] for _ in range(min(shards, len(modules)))]
    for index, module in enumerate(modules):
        buckets[index % len(buckets)].append(module)
    result = []
    for os_name in ["ubuntu-24.04", "macos-15"]:
        for index, bucket in enumerate(buckets):
            names = {module["name"] for module in bucket}
            result.append({"os": os_name, "shard": index + 1, "modules": bucket,
                           "browser": bool(names & {"cypress", "playwright"}),
                           "bun": bool(names & {"cypress", "playwright", "gh-artifact", "gitlab-artifacts", "scorecard", "nix-publish", "black", "prettier", "rustfmt", "ruff", "biome", "shellcheck", "yamllint", "sqlfluff", "protolint", "sqruff"}),
                           "build": bool(names & {"cmake", "meson", "ninja", "sccache"}),
                           "formatters": bool(names & {"black", "prettier", "rustfmt", "ruff", "biome", "shellcheck", "yamllint", "sqlfluff", "protolint", "sqruff"}),
                           "uv": "uv" in names,
                           "security": sorted(names & {"betterleaks", "gitleaks", "syft"})})
    return {"include": result}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--github-output", action="store_true")
    args = parser.parse_args()
    try:
        modules = validate()
        print(f"Validated {len(modules)} modules and their declared entry points.")
        if args.github_output:
            matrix = batches(modules)
            with open(os.environ["GITHUB_OUTPUT"], "a") as output:
                output.write("matrix=" + json.dumps(matrix, separators=(",", ":")) + "\n")
    except (ValueError, KeyError, OSError, TypeError) as error:
        print(f"Module validation failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
