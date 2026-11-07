#!/usr/bin/env python3
"""Keep a reviewable inventory of every public WebAssembly pipeline function."""
import argparse
import json
import re
from pathlib import Path
import sys
import tomllib

from validate_modules import entry_points

ROOT = Path(__file__).resolve().parents[1]
PURPOSES = {
    'artifacts': 'Publish or retrieve build outputs and release assets.',
    'build': 'Configure, compile, test, or inspect a build graph.',
    'caching': 'Reuse build outputs or compiler results across CI jobs.',
    'cloud': 'Inspect accounts, provision resources, or transfer deployment outputs.',
    'code-quality': 'Upload coverage or run a code quality analysis.',
    'containers': 'Build, tag, publish, or inspect container images and build caches.',
    'deployment': 'Deploy an application and inspect its rollout or service state.',
    'formatting': 'Format source files or fail CI when formatting differs.',
    'infrastructure': 'Validate, preview, apply, or inspect infrastructure changes.',
    'linting': 'Check source or configuration and fail on lint violations.',
    'package-management': 'Resolve, lock, build, or publish project dependencies.',
    'packaging': 'Validate a Linux package tree and produce an architecture-specific package.',
    'publishing': 'Publish built packages to a package repository.',
    'secrets': 'Inject secrets into child commands or manage secret metadata and files.',
    'security': 'Produce security findings, inventory dependencies, or enforce a security gate.',
    'setup': 'Install and verify a prerequisite tool, select its version, and publish PATH.',
    'testing': 'Install test dependencies or browsers, run tests, and propagate failures.',
}
DIAGNOSTICS = {'version', 'help', 'du', 'stats', 'cache_list', 'targets', 'query', 'lsjson'}


def inventory():
    registry = tomllib.loads((ROOT / 'fluentci.toml').read_text())['modules']
    catalog = {t['path']: t for t in json.loads((ROOT / 'lib/cli/catalog.json').read_text())}
    setup_tools = {t['name'] for t in json.loads((ROOT / 'lib/setup/tools.json').read_text())}
    rows = []
    for module in registry:
        path = module['path']
        category, tool = path.split('/')
        if category not in PURPOSES:
            raise ValueError(f'{path}: needs an explicit pipeline purpose')
        exports = entry_points(ROOT / path)
        if category == 'setup' and module['name'] != 'setup-' + tool:
            raise ValueError(f'{path}: setup registration must use the setup- prefix')
        if category != 'setup' and tool not in setup_tools and path not in catalog:
            # Legacy modules have separately reviewed setup companions.
            if tool not in {'cachix', 'gemfury', 'buildx', 'dpkg', 'rpmbuild'}:
                raise ValueError(f'{path}: missing prerequisite installation contract')
        if category != 'setup' and not (ROOT / 'setup' / module['name'] / 'entry.mjs').exists():
            raise ValueError(f'{path}: missing setup companion')
        commands = {c['name']: c for c in catalog.get(path, {}).get('commands', [])}
        if commands and set(commands) != set(exports):
            raise ValueError(f'{path}: exported functions differ from reviewed catalog')
        functions = []
        for name in exports:
            role = 'escape hatch' if name == 'run' else 'diagnostic' if name in DIAGNOSTICS else 'pipeline operation'
            description = commands.get(name, {}).get('description', '')
            if commands and not description.strip():
                raise ValueError(f'{path}/{name}: missing function purpose')
            wit_name=re.sub(r'([a-z0-9])([A-Z])',r'\1-\2',name).replace('_','-').lower()
            functions.append(f'`{wit_name}` ({role})')
        rows.append(f'| [{module["name"]}](../{path}/README.md) | {PURPOSES[category]} | {", ".join(functions)} |')
    return registry, rows


def render():
    registry, rows = inventory()
    return '\n'.join([
        '# Pipeline module audit', '',
        f'The registry contains {len(registry)} modules. This inventory covers every public',
        'native component function, including diagnostics and literal-argument escape hatches.',
        'Modules require FluentCI v0.17.2+ and use typed named arguments and native returns.',
        'Regenerate with `python3 scripts/audit_modules.py`; CI checks for drift.', '',
        '## Execution and failure contracts', '',
        '- Setup functions install prerequisites, verify the executable/version, and publish PATH.',
        '  Native repositories determine BSD availability; package failures remain failures.',
        '  Nix installers reject BSD; dpkg and rpmbuild reject non-Linux hosts.',
        '- CLI functions validate typed input, OS, working directory, and executable before execution.',
        '  Upload file arguments marked in the catalog are checked before starting the command.',
        '  Every invocation needs a fresh run directory, records stdout/stderr and result JSON,',
        '  and propagates a nonzero command exit, timeout, cancellation, or host failure.',
        '- `artifacts` uses typed NAME=PATH string lists to declare output files for size/SHA-256 reporting. Output files and',
        '  remote identifiers still depend on the native command; see each module’s OPTIONS.md.',
        '- Diagnostics support toolchain troubleshooting and cache inspection; `run` supports',
        '  native features without inventing unsupported service endpoints. Ubicloud is a',
        '  server-defined CLI and deliberately relies on authenticated command discovery.',
        '- Accounts, registries, clusters, remote caches, and secret services use inherited',
        '  credentials or existing native configuration. Tokens do not belong in module JSON.', '',
        '## Policy decisions for pipeline authors', '',
        '- Formatter check exports and lint/test exports are gates; format/install exports mutate files.',
        '- Scorecard scan produces findings; its `gate` export enforces a minimum per-check score.',
        '  Syft produces an SBOM; use Grype or Trivy to evaluate vulnerabilities in that inventory.',
        '- SonarScanner needs the server-side quality gate wait option when a blocking gate is needed.',
        '  Coverage upload success confirms delivery, not a passing coverage threshold.',
        '- Terraform/OpenTofu plans do not enable detailed exit codes by default. Use the native',
        '  options deliberately: exit code 2 is treated as a failed task by the shared executor.',
        '- Preview deployments and infrastructure plans are available separately from mutations.',
        '  Apply/destroy/deploy exports execute immediately; review and approvals belong in the CI engine.',
        '- GitHub job upload requires the Actions runtime; GitLab job upload requires an active job token.',
        '  Release upload functions serve other runners. Tangled requires a pushed annotated tag',
        '  and the repository owner’s app password in its uploader environment variable.',
        '- Docker/Podman and build daemons, Kubernetes contexts, Python/Java/Ruby toolchains, and',
        '  native mobile SDKs remain host prerequisites where documented. Installing a CLI does',
        '  not start a daemon, create an account, or provision a cluster.',
        '- Mutable channels such as latest should be pinned for reproducibility. Native package',
        '  selectors must exist in the configured repository. XTP has a latest-only public endpoint;',
        '  Python PDK v0.1.5 has no Linux ARM64 release. These limitations are explicit failures.', '',
        '## Validation scope', '',
        'Compiled PureScript tests cover argv, input rejection, supported OS routing, failure',
        'propagation, environment publication, and artifact declarations. Local fixtures cover',
        'native packaging/builds, formatting/linting, browsers, secret detection, and SBOM output',
        'when their tools are installed. Upload adapters use synthetic credentials and controlled',
        'responses. No live cloud deployment, secret service mutation, or paid upload is claimed.',
        'BSD package routing is fixture-tested; availability varies by OS release and repository.', '',
        '## Export inventory', '',
        '| Module | CI/CD purpose | Public functions |',
        '| --- | --- | --- |', *rows, '',
    ])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    target = ROOT / 'docs/PIPELINE_AUDIT.md'
    expected = render()
    if args.check:
        if not target.exists() or target.read_text() != expected:
            print('Pipeline audit is stale; run python3 scripts/audit_modules.py', file=sys.stderr)
            return 1
    else:
        target.parent.mkdir(exist_ok=True)
        target.write_text(expected)
    print('Every registered public function has a pipeline purpose and prerequisite contract.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
