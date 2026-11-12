"""Static publishing and dependency contracts; real WIT composition runs in module CI."""
import json
from pathlib import Path
import tomllib
import unittest

ROOT = Path(__file__).resolve().parents[2]


class ModuleDependencies(unittest.TestCase):
    def test_every_operation_has_its_setup_component_and_only_installer_dependencies(self):
        registry = tomllib.loads((ROOT / 'fluentci.toml').read_text())['modules']
        modules = {m['name']: m for m in registry}
        graph = {}
        for module in registry:
            directory = ROOT / module['path']
            manifest = tomllib.loads((directory / 'fluentci-module.toml').read_text())
            self.assertEqual(manifest['name'], module['name'])
            self.assertEqual(manifest['version'], module['version'])
            self.assertEqual(manifest['runtime'], 'component')
            dependencies = manifest.get('dependencies', {})
            graph[module['name']] = list(dependencies)
            if not module['path'].startswith('setup/'):
                if module['name'] == 'nix-publish':
                    self.assertTrue({'setup-nix', 'setup-bun', 'setup-flakehub-push'} <= dependencies.keys())
                else:
                    self.assertIn('setup-' + module['name'], dependencies)
            for alias, definition in dependencies.items():
                self.assertTrue(alias.startswith('setup-'))
                self.assertNotEqual(alias, module['name'])
                self.assertIn(alias, modules)
                target = (directory / definition['path']).resolve()
                self.assertEqual(target, (ROOT / modules[alias]['path']).resolve())
                schema = json.loads((target / 'schema.json').read_text())
                self.assertFalse(schema['exports']['setup']['input'].get('required'))
                self.assertEqual(definition['runtime'], 'component')
            lock = json.loads((directory / 'fluentci.lock').read_text())
            self.assertEqual({key.split('::', 1)[1] for key in lock['modules']}, set(dependencies))
            for key, value in lock['modules'].items():
                self.assertTrue(value.startswith('path:'))
                locked = tomllib.loads(value.removeprefix('path:'))
                self.assertEqual(locked['name'], key.split('::', 1)[1])
                self.assertEqual(locked['path'], dependencies[locked['name']]['path'])
        def visit(node, stack):
            self.assertNotIn(node, stack, 'Cyclic setup dependency graph')
            for child in graph[node]:
                visit(child, [*stack, node])
        for name in graph:
            visit(name, [])

    def test_runtime_imports_and_declared_dependencies_agree(self):
        for module in tomllib.loads((ROOT / 'fluentci.toml').read_text())['modules']:
            if module['path'].startswith('setup/'):
                continue
            directory = ROOT / module['path']
            manifest = tomllib.loads((directory / 'fluentci-module.toml').read_text())
            ffi = (directory / 'src/CI/ModuleDependencies.js').read_text()
            for alias in manifest['dependencies']:
                self.assertIn('fluentci:dependency/' + alias, ffi)
            source = (directory / 'src/CI/Component.purs').read_text()
            self.assertIn('Dependencies.ensureFor', source)
            self.assertTrue((directory / 'test/dependencies.test.mjs').is_file())


if __name__ == '__main__':
    unittest.main()
