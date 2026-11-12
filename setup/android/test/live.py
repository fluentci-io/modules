#!/usr/bin/env python3
"""Real component/Java/Google SDK integration; invoked only by the opted-in CI test."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

MODULE = Path(__file__).resolve().parents[1]
ROOT = MODULE.parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from setup_ci_toolchain import setup_result, apply_result


def checked(argv, environment, cwd=MODULE):
    result = subprocess.run(argv, cwd=cwd, env=environment, text=True, capture_output=True, timeout=900)
    if result.stdout:
        print(result.stdout, end='', flush=True)
    if result.stderr:
        print(result.stderr, end='', file=sys.stderr, flush=True)
    if result.returncode:
        raise RuntimeError(f'{argv[0]} failed with status {result.returncode}')
    return result.stdout + result.stderr


def main():
    if sys.platform not in ('linux', 'darwin'):
        raise RuntimeError('Android live test supports Linux/macOS only')
    cli = shutil.which('fluentci')
    if not cli:
        raise RuntimeError('FluentCI v0.17.3+ is required for native component composition')
    environment = dict(os.environ)
    with tempfile.TemporaryDirectory(prefix='fluentci-android-e2e-') as directory:
        sdk = Path(directory) / "sdk with spaces ' literal"
        base = [cli, 'run', '.', 'setup', '--sdk-root', str(sdk)]
        # Execute the source module so its actual WIT dependency is composed.
        output = checked(base + ['--api-levels', '36', '--build-tools-versions', '36.0.0'], environment)
        result = setup_result(output)
        if result['sdk-root'] != str(sdk) or not result['java-version'].startswith('21.'):
            raise AssertionError('SDK root or default Java 21 was not returned')
        apply_result(result, environment, 'android')
        java = Path(environment['JAVA_HOME']) / 'bin/java'
        if not java.is_file() or '21.' not in checked([str(java), '-version'], environment):
            raise AssertionError('setup-java did not provide a working Java 21')
        for path in ['cmdline-tools/latest/bin/sdkmanager', 'platform-tools/adb', 'platforms/android-36/android.jar', 'build-tools/36.0.0/aapt2']:
            if not (sdk / path).is_file():
                raise AssertionError('Missing SDK output: ' + path)
        checked(['sdkmanager', '--sdk_root=' + str(sdk), '--version'], environment)
        checked(['adb', 'version'], environment)
        checked([str(sdk / 'build-tools/36.0.0/aapt2'), 'version'], environment)
        installed = checked(['sdkmanager', '--sdk_root=' + str(sdk), '--list_installed'], environment)
        for package in ['platform-tools', 'platforms;android-36', 'build-tools;36.0.0']:
            if package not in installed:
                raise AssertionError('sdkmanager did not list installed package: ' + package)
        marker = sdk / 'cmdline-tools/latest/.fluentci-archive-sha256'
        marker_before = (marker.read_text(), marker.stat().st_mtime_ns)
        # Prove Java override forwarding through the real dependency and cached SDK reuse.
        output = checked(base + ['--java-version', '25', '--packages', '', '--accept-licenses=false'], environment)
        override = setup_result(output)
        if not override['java-version'].startswith('25.'):
            raise AssertionError('Java version override was not forwarded to setup-java')
        apply_result(override, environment, 'android')
        checked([str(Path(environment['JAVA_HOME']) / 'bin/java'), '-version'], environment)
        if marker_before != (marker.read_text(), marker.stat().st_mtime_ns):
            raise AssertionError('Cached SDK bootstrap was unexpectedly replaced')
        failure = subprocess.run(base + ['--packages', 'fluentci-missing-sdk-package;fixture'], cwd=MODULE, env=environment, text=True, capture_output=True, timeout=300)
        if failure.returncode == 0:
            raise AssertionError('Invalid native SDK package did not fail the component')
        try:
            setup_result(failure.stdout)
        except ValueError:
            pass
        else:
            raise AssertionError('Failed SDK installation returned a successful setup record')
        print(json.dumps({'sdkRoot': str(sdk), 'defaultJava': result['java-version'], 'overrideJava': override['java-version'], 'checks': ['component composition', 'Java', 'sdkmanager', 'adb', 'aapt2', 'platform', 'build-tools', 'cache reuse', 'native failure propagation']}))


if __name__ == '__main__':
    main()
