import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "scripts"))
from validate_modules import validate


class ModuleValidationTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.module = self.root / "setup/example"
        self.module.mkdir(parents=True)
        (self.root / "LICENSE").write_text("MIT License\n")
        (self.root / "fluentci.toml").write_text('[[modules]]\nname="example"\nversion="0.1.0"\npath="setup/example"\nsdk="purescript"\nruntime="component"\n')
        package = {"name": "example", "license": "MIT", "scripts": {"build": "node build.mjs", "test": "node --test"}}
        files = {
            "README.md": "# Example\n", "LICENSE": "MIT License\n",
            "package.json": json.dumps(package),
            "package-lock.json": json.dumps({"name": "example", "packages": {"": {"name": "example", "license": "MIT"}}}),
            "spago.yaml": "package:\n  name: example\n", "spago.lock": "{}",
            "build.mjs": "", "entry.mjs": 'export { setup } from "./output/Main/index.js";\n',
            "schema.json": json.dumps({"runtime":"component","exports":{"setup":{}}}),
            ".gitignore": "dist/\n", "test.test.mjs": "",
        }
        for name, text in files.items():
            (self.module / name).write_text(text)
        (self.module / "src").mkdir()
        (self.module / "src/CI").mkdir()
        (self.module / "src/CI/Component.purs").write_text("module CI.Component where\nsetup :: { version :: String } -> Effect String\n")

    def test_complete_module_is_included(self):
        self.assertEqual(validate(self.root), [{"name": "example", "path": "setup/example"}])

    def test_unregistered_source_cannot_be_silently_skipped(self):
        other = self.root / "setup/other"
        other.mkdir()
        (other / "entry.mjs").write_text("export {};")
        with self.assertRaisesRegex(ValueError, "unregistered"):
            validate(self.root)

    def test_empty_named_directory_cannot_be_silently_skipped(self):
        (self.root / 'setup/empty').mkdir()
        with self.assertRaisesRegex(ValueError, 'unregistered'):
            validate(self.root)

    def test_missing_tests_are_rejected(self):
        (self.module / "test.test.mjs").unlink()
        with self.assertRaisesRegex(ValueError, "test suite"):
            validate(self.root)

    def test_missing_build_manifest_is_rejected(self):
        (self.module / "spago.lock").unlink()
        with self.assertRaisesRegex(ValueError, "spago.lock"):
            validate(self.root)

    def test_declared_guest_exports_must_match(self):
        (self.module / "src/CI/Component.purs").write_text("other :: { version :: String } -> Effect String\n")
        with self.assertRaisesRegex(ValueError, "entry points"):
            validate(self.root)

    def test_npm_lockfile_drift_is_rejected(self):
        package = json.loads((self.module / "package.json").read_text())
        package["devDependencies"] = {"esbuild": "0.25.3"}
        (self.module / "package.json").write_text(json.dumps(package))
        with self.assertRaisesRegex(ValueError, "lockfile"):
            validate(self.root)

    def test_unsafe_registry_path_is_rejected(self):
        p = self.root / "fluentci.toml"
        p.write_text(p.read_text().replace('setup/example', '../outside'))
        with self.assertRaises(ValueError):
            validate(self.root)

    def test_duplicate_names_are_rejected(self):
        p = self.root / "fluentci.toml"
        p.write_text(p.read_text() * 2)
        with self.assertRaisesRegex(ValueError, "unique"):
            validate(self.root)


class BatchTests(unittest.TestCase):
    def test_large_registry_fits_eight_runners_and_covers_each_module(self):
        from validate_modules import batches
        modules=[{'name': 'module-'+str(i),'path':'setup/module-'+str(i)} for i in range(160)]
        matrix=batches(modules)['include']
        self.assertEqual(len(matrix),8)
        for os_name in ['ubuntu-24.04','macos-15']:
            found=[m for row in matrix if row['os']==os_name for m in row['modules']]
            self.assertCountEqual(found,modules)
            self.assertEqual(len({m['name'] for m in found}),len(modules))

    def test_small_registry_does_not_spawn_empty_runners(self):
        from validate_modules import batches
        matrix=batches([{'name':'cypress','path':'testing/cypress'}])['include']
        self.assertEqual(len(matrix),2)
        self.assertTrue(all(row['browser'] for row in matrix))


if __name__ == "__main__":
    unittest.main()
