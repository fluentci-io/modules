import hashlib
import importlib.util
import io
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('ci_toolchain', ROOT / 'scripts/setup_ci_toolchain.py')
toolchain = importlib.util.module_from_spec(spec)
spec.loader.exec_module(toolchain)


def result(tool='node'):
    return {'tool': tool, 'version': '24.22.2', 'bin-dir': '/tools/bin',
            'environment': [{'name': 'PATH', 'value': '/tools/bin:/usr/bin'}]}


class Response(io.BytesIO):
    def geturl(self):
        return 'https://downloads.example/tool.wasm'


class ToolchainTests(unittest.TestCase):
    def test_native_result_is_read_despite_command_output_and_pretty_json(self):
        value = result()
        self.assertEqual(toolchain.setup_result('checking tools\n' + json.dumps(value, indent=2) + '\n'), value)
        with self.assertRaisesRegex(ValueError, 'typed installation'):
            toolchain.setup_result('installation failed\n')

    def test_typed_environment_is_validated_before_application(self):
        environment = {'PATH': '/usr/bin'}
        toolchain.apply_result(result(), environment, 'node')
        self.assertEqual(environment['PATH'], '/tools/bin:/usr/bin')
        for updates in [{'tool': 'different'}, {'version': ''}, {'bin-dir': 'relative'},
                        {'environment': {}}, {'environment': ['invalid']},
                        {'environment': [{'name': 'PATH', 'value': '/usr/bin'}]}]:
            with self.subTest(updates=updates), self.assertRaises(ValueError):
                toolchain.apply_result({**result(), **updates}, {'PATH': '/usr/bin'}, 'node')

    def test_checksums_are_required_for_cached_and_downloaded_artifacts(self):
        content = b'component fixture'
        digest = hashlib.sha256(content).hexdigest()
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / 'tool.wasm'
            path.write_bytes(content)
            with patch.object(toolchain.urllib.request, 'urlopen') as request:
                self.assertEqual(toolchain.verified_download('https://example.com/module.wasm', digest, path), path)
                request.assert_not_called()
            path.write_bytes(b'corrupted cache')
            with patch.object(toolchain.urllib.request, 'urlopen', return_value=Response(content)):
                toolchain.verified_download('https://example.com/module.wasm', digest, path)
            self.assertEqual(path.read_bytes(), content)
            with patch.object(toolchain.urllib.request, 'urlopen', return_value=Response(b'bad download')):
                with self.assertRaisesRegex(ValueError, 'SHA-256 mismatch'):
                    toolchain.verified_download('https://example.com/module.wasm', '0' * 64, path)
            self.assertEqual(path.read_bytes(), content)
            with self.assertRaises(ValueError):
                toolchain.verified_download('http://example.com/module.wasm', digest, path)

    def test_registry_response_must_match_pinned_publisher_name_and_version(self):
        registry = {'url': 'https://registry.example', 'publisher': 'fluentci.io', 'publisherDid': 'did:plc:fixture'}
        definition = {'name': 'setup-node', 'version': '0.2.0'}
        package = {**definition, 'author': registry['publisherDid'], 'url': 'https://downloads.example/tool.wasm', 'sha256': 'a' * 64}
        for changes in [{'author': 'did:plc:other'}, {'version': '0.3.0'}, {'name': 'different'}, {'sha256': ''}, {'url': 'http://example.com/tool.wasm'}]:
            payload = json.dumps({'package': {**package, **changes}}).encode()
            with patch.object(toolchain.urllib.request, 'urlopen', return_value=Response(payload)):
                with self.subTest(changes=changes), self.assertRaises(ValueError):
                    toolchain.resolve_module(registry, definition)

    def test_github_environment_keeps_final_path_precedence(self):
        with tempfile.TemporaryDirectory() as temporary:
            path_file = Path(temporary) / 'path'
            env_file = Path(temporary) / 'environment'
            with patch.dict(os.environ, {'GITHUB_PATH': str(path_file), 'GITHUB_ENV': str(env_file)}):
                toolchain.export_environment({'PATH': '/usr/bin'}, {'PATH': '/python/bin:/purs/bin:/node/bin:/usr/bin', 'JAVA_HOME': '/jdk'})
            self.assertEqual(path_file.read_text().splitlines(), ['/node/bin', '/purs/bin', '/python/bin'])
            self.assertIn('JAVA_HOME<<fluentci_', env_file.read_text())
            self.assertIn('\n/jdk\n', env_file.read_text())
            self.assertNotIn('PATH<<', env_file.read_text())

    def test_bootstrap_executes_explicit_component_files(self):
        with patch.object(toolchain, 'command', return_value=json.dumps(result())) as command:
            environment = {'PATH': '/usr/bin'}
            toolchain.run_component('/cache/fluentci', '/cache/setup-node.wasm', ['--version', '24.22.2'], environment, 'node')
            self.assertEqual(command.call_args.args[0], ['/cache/fluentci', 'run', '--wasm', '/cache/setup-node.wasm', 'setup', '--version', '24.22.2'])
            self.assertEqual(environment['PATH'], '/tools/bin:/usr/bin')

    def test_profiles_use_fresh_prefixes_without_repeating_purescript_prerequisites(self):
        config = json.loads((ROOT / '.github/toolchain/versions.json').read_text())
        for profile, expected in [('base', ['node', 'bun', 'uv']), ('full', ['purescript', 'uv'])]:
            with tempfile.TemporaryDirectory() as temporary:
                root = Path(temporary)
                python = root / 'python'
                python.touch()
                environment = {'PATH': '/usr/bin', 'RUNNER_TEMP': str(root)}
                def run(argv, env):
                    return str(python) if argv[:3] == ['uv', 'python', 'find'] else 'fixture version'
                package = {'url': 'https://example.com/component.wasm', 'sha256': 'a' * 64}
                with patch.object(toolchain, 'install_cli', return_value=root / 'fluentci'), \
                     patch.object(toolchain, 'resolve_module', return_value=package), \
                     patch.object(toolchain, 'verified_download', return_value=root / 'component.wasm'), \
                     patch.object(toolchain, 'run_component') as component, \
                     patch.object(toolchain, 'command', side_effect=run):
                    toolchain.setup_toolchain(profile, config, root / 'cache', environment)
                self.assertEqual([call.args[4] for call in component.call_args_list], expected)
                prefixes = []
                for call in component.call_args_list:
                    arguments = call.args[2]
                    self.assertEqual(arguments[-2], '--install-dir')
                    prefix = Path(arguments[-1])
                    self.assertTrue(prefix.is_absolute())
                    self.assertFalse(prefix.exists(), 'SDK must exclusively create the install directory')
                    self.assertEqual(prefix.name, call.args[4])
                    prefixes.append(prefix)
                self.assertEqual(len(prefixes), len(set(prefixes)))
                self.assertEqual(environment['PATH'].split(os.pathsep)[0], str(python.parent))

    def test_workflows_use_published_setup_modules_without_third_party_setup_actions(self):
        files = list((ROOT / '.github/workflows').glob('*.yml')) + [ROOT / '.github/actions/setup-toolchain/action.yml']
        for file in files:
            self.assertNotRegex(file.read_text(), r'uses:\s*(?:actions/setup-|oven-sh/setup-bun)')
        config = json.loads((ROOT / '.github/toolchain/versions.json').read_text())
        self.assertEqual(set(config['modules']), {'node', 'bun', 'uv', 'purescript'})
        for module in config['modules'].values():
            self.assertRegex(module['version'], r'^\d+\.\d+\.\d+$')
        self.assertGreaterEqual(tuple(map(int, config['fluentci']['version'].split('.'))), (0, 17, 4),
                                'Services E2E requires dynamic HTTP probe validation from 0.17.4')
        self.assertEqual(len(config['fluentci']['assets']), 4)
        for asset in config['fluentci']['assets'].values():
            self.assertIn('/v' + config['fluentci']['version'] + '/fluentci_v' + config['fluentci']['version'] + '_', asset['url'])
            self.assertRegex(asset['sha256'], r'^[0-9a-f]{64}$')


if __name__ == '__main__':
    unittest.main()
