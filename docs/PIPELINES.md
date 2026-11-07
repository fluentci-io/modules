# Using modules in CI/CD

FluentCI runs the same compiled modules inside GitHub Actions, Jenkins agents,
Tekton steps, or another runner with the FluentCI host installed. Check out this
repository with its `fluentci.toml`, build the modules you use, and supply plugin
input as the final argument to `fluentci run MODULE FUNCTION INPUT`.

Setup names use `setup-`: `setup-cmake` installs CMake, while `cmake` configures,
builds, installs, and tests a project. Setup publishes PATH to subsequent tasks
in the same FluentCI host session. Separate CI processes should use a fixed
installation prefix and explicitly add its `bin` directory to their PATH.

## Build and test

The following commands use the checkout as the project directory and distinct
run directories. The host needs CMake and a C compiler first; `setup-cmake` can
install a pinned CMake release. No cross-compiler is implied by package architecture
selection in dpkg or rpmbuild.

```sh
fluentci run cmake configure '{"runDir":".fluentci/configure","buildDir":"build","buildType":"Release"}'
fluentci run cmake build '{"runDir":".fluentci/build","buildDir":"build","parallel":2}'
fluentci run cmake test '{"runDir":".fluentci/test","buildDir":"build"}'
```

A failed native command fails the module invocation. Do not reuse a `runDir` on
reruns: include the CI run ID or remove the previous workspace through your CI
engine's workspace lifecycle. The task logs and result JSON live in that directory.
Declare output files with `"artifacts":{"package":"dist/package.tar.gz"}` to
include file sizes and SHA-256 metadata in the execution report. The CI engine
still controls retention and cross-job transfer of those files.

## GitHub Actions

After installing FluentCI and building the required modules in your runner image,
a job can invoke them with ordinary shell steps:

```yaml
steps:
  - uses: actions/checkout@v6
  - name: Check formatting
    run: >-
      fluentci run prettier check
      '{"runDir":".fluentci/format","files":["src"]}'
  - name: Run tests
    run: >-
      fluentci run cmake test
      '{"runDir":".fluentci/test","buildDir":"build"}'
```

These snippets assume the tool executables and build directory already exist.
For job uploads, `gh-artifact.upload` needs the Actions runtime token and results
URL made available to the process; a repository `GITHUB_TOKEN` alone is insufficient.
`setup-gh-artifact` installs its official artifact client through Bun. A normal
Actions artifact action can also collect the output paths and run directories.
Use `gh-artifact.release_upload` for release assets from another CI provider.

## Jenkins

Keep credentials in Jenkins bindings, with a clean workspace and tool-equipped
agent. Module input contains configuration and paths, never token values.

```groovy
stage('Validate') {
  steps {
    sh '''
      fluentci run terraform init '{"runDir":".fluentci/init"}'
      fluentci run terraform validate '{"runDir":".fluentci/validate"}'
      fluentci run terraform plan '{"runDir":".fluentci/plan","out":"plan.tfplan"}'
    '''
    archiveArtifacts artifacts: 'plan.tfplan', fingerprint: true
  }
}
```

Configure backend/cloud credentials on the agent through Jenkins bindings. Put
an approval stage before invoking `apply`. Terraform plan files and logs can
contain sensitive infrastructure values, so use appropriate retention/access.

## Tekton

Use a Task step image containing FluentCI, the compiled modules, and prerequisites,
with a workspace for the source checkout. Let Tekton handle Kubernetes secrets,
workspaces, results, and approval policy. A failed module invocation fails the step.

```yaml
steps:
  - name: scan
    image: your-registry/fluentci-tools:pinned
    workingDir: $(workspaces.source.path)
    script: |
      #!/bin/sh
      set -eu
      fluentci run trivy filesystem '{"runDir":".fluentci/trivy","directory":"."}'
```

The runner image must provide the configured Trivy database/network access.
For artifact transfer outside GitHub/GitLab jobs, use ORAS, JFrog, Nexus RAW,
rclone, or a release uploader with the native credentials supplied by the Task.

See the [audit](./PIPELINE_AUDIT.md) for each export's role, gating limitations,
platform constraints, and the distinction between controlled tests and live services.
