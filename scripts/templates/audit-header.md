# Pipeline module audit

The registry contains {{count}} modules. This inventory covers every public
native component function, including diagnostics and literal-argument escape hatches.
Modules require FluentCI v0.17.2+ and use typed named arguments and native returns.
Regenerate with `escript scripts/fluentci_modules_ci audit-modules`; CI checks for drift.

## Execution and failure contracts

- Setup functions install prerequisites, verify the executable/version, and publish PATH.
  Native repositories determine BSD availability; package failures remain failures.
  Nix installers reject BSD; dpkg and rpmbuild reject non-Linux hosts.
- CLI functions validate typed input, OS, working directory, and executable before execution.
  Upload file arguments marked in the catalog are checked before starting the command.
  Every invocation needs a fresh run directory, records stdout/stderr and result JSON,
  and propagates a nonzero command exit, timeout, cancellation, or host failure.
- `artifacts` uses typed NAME=PATH string lists to declare output files for size/SHA-256 reporting. Output files and
  remote identifiers still depend on the native command; see each module’s OPTIONS.md.
- Diagnostics support toolchain troubleshooting and cache inspection; `run` supports
  native features without inventing unsupported service endpoints. Ubicloud is a
  server-defined CLI and deliberately relies on authenticated command discovery.
- Accounts, registries, clusters, remote caches, and secret services use inherited
  credentials or existing native configuration. Tokens do not belong in module JSON.

## Policy decisions for pipeline authors

- Formatter check exports and lint/test exports are gates; format/install exports mutate files.
- Scorecard scan produces findings; its `gate` export enforces a minimum per-check score.
  Syft produces an SBOM; use Grype or Trivy to evaluate vulnerabilities in that inventory.
- sonarqube wraps the sonar CLI; sonarqube-scanner submits full-project Scanner analysis.
  Scanner needs its server-side quality gate wait option when a blocking gate is needed.
  Coverage upload success confirms delivery, not a passing coverage threshold.
- Terraform/OpenTofu plans do not enable detailed exit codes by default. Use the native
  options deliberately: exit code 2 is treated as a failed task by the shared executor.
- Preview deployments and infrastructure plans are available separately from mutations.
  Apply/destroy/deploy exports execute immediately; review and approvals belong in the CI engine.
- GitHub job upload requires the Actions runtime; GitLab job upload requires an active job token.
  Release upload functions serve other runners. Tangled requires a pushed annotated tag
  and the repository owner’s app password in its uploader environment variable.
- Docker/Podman and build daemons, Kubernetes contexts, Python/Java/Ruby toolchains, and
  native mobile SDKs remain host prerequisites where documented. Installing a CLI does
  not start a daemon, create an account, or provision a cluster.
- Mutable channels such as latest should be pinned for reproducibility. Native package
  selectors must exist in the configured repository. XTP has a latest-only public endpoint;
  Python PDK v0.1.5 has no Linux ARM64 release. These limitations are explicit failures.

## Validation scope

Compiled PureScript tests cover argv, input rejection, supported OS routing, failure
propagation, environment publication, and artifact declarations. Local fixtures cover
native packaging/builds, formatting/linting, browsers, secret detection, and SBOM output
when their tools are installed. Upload adapters use synthetic credentials and controlled
responses. No live cloud deployment, secret service mutation, or paid upload is claimed.
BSD package routing is fixture-tested; availability varies by OS release and repository.

