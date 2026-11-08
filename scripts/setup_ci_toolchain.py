#!/usr/bin/env python3
"""Bootstrap CI with checksum-verified published FluentCI setup components.

Requires only the runner's existing Python 3.9+ interpreter. Component execution
and all runtime installation happen when this script is invoked by CI.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import urllib.parse
import urllib.request
import uuid

ROOT = Path(__file__).resolve().parents[1]
MAX_DOWNLOAD = 128 * 1024 * 1024


def https_url(value):
    parsed = urllib.parse.urlsplit(value)
    if parsed.scheme != 'https' or not parsed.hostname or parsed.username or parsed.password:
        raise ValueError('Setup downloads require an HTTPS URL without credentials')
    return value


def digest_file(path):
    digest = hashlib.sha256()
    with path.open('rb') as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b''):
            digest.update(chunk)
    return digest.hexdigest()


def verified_download(url, digest, destination):
    https_url(url)
    if not re.fullmatch(r'[0-9a-f]{64}', digest):
        raise ValueError('Setup artifact is missing a valid SHA-256')
    if destination.is_file() and digest_file(destination) == digest:
        return destination
    destination.parent.mkdir(parents=True, exist_ok=True)
    request = urllib.request.Request(url, headers={'User-Agent': 'fluentci-modules-ci'})
    temporary = None
    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            https_url(response.geturl())
            with tempfile.NamedTemporaryFile(dir=destination.parent, delete=False) as output:
                temporary = Path(output.name)
                size = 0
                for chunk in iter(lambda: response.read(1024 * 1024), b''):
                    size += len(chunk)
                    if size > MAX_DOWNLOAD:
                        raise ValueError('Setup artifact exceeds the download size limit')
                    output.write(chunk)
        if digest_file(temporary) != digest:
            raise ValueError('Setup artifact SHA-256 mismatch')
        temporary.replace(destination)
        return destination
    finally:
        if temporary is not None and temporary.exists():
            temporary.unlink()


def resolve_module(registry, definition):
    query = urllib.parse.urlencode({'author': registry['publisher'],
                                   'name': definition['name'], 'version': definition['version']})
    url = https_url(registry['url'].rstrip('/') + '/xrpc/io.fluentci.registry.getPackage?' + query)
    with urllib.request.urlopen(url, timeout=60) as response:
        https_url(response.geturl())
        package = json.load(response)['package']
    if package.get('name') != definition['name'] or package.get('version') != definition['version']:
        raise ValueError('Registry returned a different setup package or version')
    if package.get('author') != registry['publisherDid']:
        raise ValueError('Registry returned an unexpected setup publisher')
    https_url(package['url'])
    if not re.fullmatch(r'[0-9a-f]{64}', package.get('sha256', '')):
        raise ValueError('Registry did not return a valid setup artifact checksum')
    return package


def host_key():
    os_name = {'Darwin': 'macos', 'Linux': 'linux'}.get(platform.system())
    arch = {'arm64': 'aarch64', 'aarch64': 'aarch64',
            'x86_64': 'x86_64', 'AMD64': 'x86_64'}.get(platform.machine())
    if not os_name or not arch:
        raise ValueError('CI bootstrap supports Linux/macOS on x86_64 or aarch64')
    return os_name + '-' + arch


def install_cli(config, cache):
    asset = config['assets'][host_key()]
    archive = verified_download(asset['url'], asset['sha256'],
                                cache / 'cli' / config['version'] / 'release.tar.gz')
    binary = archive.parent / 'bin' / 'fluentci'
    binary.parent.mkdir(parents=True, exist_ok=True)
    with tarfile.open(archive, 'r:gz') as bundle:
        members = [item for item in bundle.getmembers()
                   if item.isfile() and Path(item.name).name == 'fluentci']
        if len(members) != 1:
            raise ValueError('CLI archive must contain exactly one fluentci binary')
        with bundle.extractfile(members[0]) as source, binary.open('wb') as output:
            shutil.copyfileobj(source, output)
    binary.chmod(0o755)
    return binary


def command(argv, environment):
    result = subprocess.run(list(map(str, argv)), env=environment, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.stderr:
        print(result.stderr, file=sys.stderr, end='', flush=True)
    if result.returncode:
        if result.stdout:
            print(result.stdout, end='', flush=True)
        raise RuntimeError('CI setup command failed: ' + str(argv[0]))
    return result.stdout


def setup_result(output):
    decoder = json.JSONDecoder()
    for match in reversed(list(re.finditer(r'\{', output))):
        try:
            value, _ = decoder.raw_decode(output, match.start())
        except ValueError:
            continue
        if isinstance(value, dict) and 'bin-dir' in value and 'environment' in value:
            return value
    raise ValueError('Setup component did not return its typed installation result')


def apply_result(result, environment, expected_tool=None):
    if any(not isinstance(result.get(key), str) or not result[key].strip() for key in ['tool', 'version']):
        raise ValueError('Setup component returned an invalid tool/version')
    if expected_tool is not None and result.get('tool') != expected_tool:
        raise ValueError('Unexpected tool in setup component result')
    directory = result.get('bin-dir')
    if not isinstance(directory, str) or not Path(directory).is_absolute() or '\n' in directory or '\r' in directory or '\0' in directory:
        raise ValueError('Setup component returned an invalid bin-dir')
    bindings = result.get('environment')
    if not isinstance(bindings, list):
        raise ValueError('Setup environment must be a native list of name/value records')
    updates = {}
    for binding in bindings:
        if not isinstance(binding, dict):
            raise ValueError('Invalid setup environment binding')
        name, value = binding.get('name'), binding.get('value')
        if not isinstance(name, str) or not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*', name):
            raise ValueError('Invalid setup environment variable name')
        if not isinstance(value, str) or '\0' in value:
            raise ValueError('Invalid setup environment value')
        if name in updates:
            raise ValueError('Duplicate setup environment variable')
        updates[name] = value
    if directory not in updates.get('PATH', '').split(os.pathsep):
        raise ValueError('Setup result did not publish its installation directory to PATH')
    environment.update(updates)


def run_component(cli, artifact, arguments, environment, expected_tool=None):
    output = command([cli, 'run', '--wasm', artifact, 'setup', *arguments], environment)
    result = setup_result(output)
    apply_result(result, environment, expected_tool)
    print('Configured ' + result['tool'] + ' ' + result['version'], flush=True)
    return result


def export_environment(before, after):
    paths = after.get('PATH', '').split(os.pathsep)
    old_paths = before.get('PATH', '').split(os.pathsep)
    new_paths = list(dict.fromkeys(path for path in paths if path and path not in old_paths))
    if any('\n' in path or '\r' in path or '\0' in path for path in new_paths):
        raise ValueError('Invalid path in setup environment')
    if os.environ.get('GITHUB_PATH'):
        with open(os.environ['GITHUB_PATH'], 'a') as output:
            # The runner prepends file entries in reverse order.
            for path in reversed(new_paths):
                output.write(path + '\n')
    if os.environ.get('GITHUB_ENV'):
        with open(os.environ['GITHUB_ENV'], 'a') as output:
            for name, value in after.items():
                if name == 'PATH' or before.get(name) == value:
                    continue
                delimiter = 'fluentci_' + uuid.uuid4().hex
                output.write(name + '<<' + delimiter + '\n' + value + '\n' + delimiter + '\n')


def setup_toolchain(profile, config, cache, environment):
    cli = install_cli(config['fluentci'], cache)
    environment['PATH'] = str(cli.parent) + os.pathsep + environment['PATH']
    for key in ['node', 'bun', 'uv'] + (['purescript'] if profile == 'full' else []):
        definition = config['modules'][key]
        print('Installing ' + definition['name'] + '@' + definition['version'], flush=True)
        package = resolve_module(config['registry'], definition)
        artifact = verified_download(package['url'], package['sha256'],
                                     cache / 'components' / (package['sha256'] + '.wasm'))
        run_component(cli, artifact, definition['arguments'], environment, key)
    command(['uv', 'python', 'install', config['python']], environment)
    python = command(['uv', 'python', 'find', '--managed-python', config['python']], environment).strip()
    if not Path(python).is_absolute() or not Path(python).is_file():
        raise ValueError('uv did not return a managed Python executable')
    environment['PATH'] = str(Path(python).parent) + os.pathsep + environment['PATH']
    for argv in [['fluentci', '--version'], ['node', '--version'], ['bun', '--version'],
                 ['uv', '--version'], [python, '--version']] + ([['purs', '--version'], ['spago', '--version']] if profile == 'full' else []):
        print(command(argv, environment).strip(), flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--profile', choices=['base', 'full'], default='full')
    parser.add_argument('--cache-dir', type=Path, default=Path.home() / '.cache/fluentci-ci')
    parser.add_argument('--file', type=Path, help='Run an already-built local setup component in CI')
    parser.add_argument('arguments', nargs=argparse.REMAINDER)
    args = parser.parse_args()
    before = os.environ.copy()
    environment = before.copy()
    if args.file:
        arguments = args.arguments[1:] if args.arguments[:1] == ['--'] else args.arguments
        run_component(shutil.which('fluentci') or 'fluentci', args.file.resolve(), arguments, environment)
    else:
        if args.arguments:
            parser.error('Trailing setup arguments require --file')
        config = json.loads((ROOT / '.github/toolchain/versions.json').read_text())
        setup_toolchain(args.profile, config, args.cache_dir.resolve(), environment)
    export_environment(before, environment)


if __name__ == '__main__':
    try:
        main()
    except (ValueError, RuntimeError, OSError, KeyError) as error:
        print('CI toolchain setup failed: ' + str(error), file=sys.stderr)
        sys.exit(1)
