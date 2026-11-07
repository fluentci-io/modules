#!/usr/bin/env python3
"""Install pinned Betterleaks/Gitleaks/Syft binaries for offline native CLI tests."""
import argparse
import hashlib
import json
from pathlib import Path
import platform
import subprocess
import tarfile
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def install(directory, names):
    records = json.loads((ROOT / 'test/cli/security-tools.json').read_text())
    machine = platform.machine().lower()
    arch = {'aarch64': 'arm64', 'x86_64': 'amd64', 'x64': 'amd64'}.get(machine, machine)
    target = platform.system().lower() + '-' + arch
    directory.mkdir(parents=True, exist_ok=True)
    for name in names:
        release = records[name]
        if target not in release['platforms']:
            raise SystemExit('No native security test binary for ' + target)
        source = release['platforms'][target]
        with tempfile.TemporaryDirectory(prefix='fluentci-security-') as temporary:
            archive = Path(temporary) / 'release.tar.gz'
            subprocess.run(['curl', '--fail', '--location', '--silent', '--show-error', '--retry', '3',
                            '--output', str(archive), source['url']], check=True)
            if hashlib.sha256(archive.read_bytes()).hexdigest() != source['sha256']:
                raise SystemExit('Checksum mismatch: ' + name)
            with tarfile.open(archive, 'r:gz') as bundle:
                member = bundle.getmember(name)
                if not member.isfile():
                    raise SystemExit('Expected a regular binary: ' + name)
                with bundle.extractfile(member) as binary:
                    (directory / name).write_bytes(binary.read())
            (directory / name).chmod(0o755)
        print('Installed ' + name + ' ' + release['version'], flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--directory', type=Path, required=True)
    parser.add_argument('--tool', choices=['betterleaks', 'gitleaks', 'syft'], action='append')
    args = parser.parse_args()
    install(args.directory.resolve(), args.tool or ['betterleaks', 'gitleaks', 'syft'])
