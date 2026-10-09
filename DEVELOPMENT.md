# Development Guide

This repository is a starter template for building an Ansible role. The role implementation is intentionally empty: `tasks/main.yml` and `handlers/main.yml` are placeholders, and the Molecule verifier currently checks only that the role can be included. Adapt the role metadata, defaults, tasks, and verification to your use case before relying on it to manage a system.

## Prerequisites

- Python 3.13
- Docker Engine available to the current user, with the daemon running
- GNU Make

Check that the required tools are available:

```bash
python3.13 --version
docker --version
docker info
make --version
```

## Configure

From the repository root, run:

```bash
make configure
```

This creates `.venv` with Python 3.13, installs the development dependencies from `requirements-dev.txt`, installs role dependencies from `requirements.yml`, and resolves Molecule dependencies for all scenarios. The Makefile invokes tools from `.venv/bin`, so activating the virtual environment is not required when using its targets.

To install only the Python development tools, use:

```bash
make install
```

To install role dependencies explicitly, use:

```bash
make requirements
make force-requirements
```

## Lint

Run both configured linters:

```bash
make lint
```

To run either directly:

```bash
make ansible-lint
make yamllint
```

These targets call:

```bash
.venv/bin/ansible-lint --profile production
.venv/bin/yamllint .
```

## Test

Run every Molecule scenario:

```bash
make test
```

The current scenarios use Alpine 3.24 and Debian Trixie Docker images. To run one scenario, or to work through individual Molecule stages, set `SCENARIO` (which defaults to `alpine`):

```bash
make test-scenario SCENARIO=debian
make molecule-create SCENARIO=alpine
make molecule-converge SCENARIO=alpine
make molecule-verify SCENARIO=alpine
make molecule-destroy SCENARIO=alpine
```

The `molecule-*` targets operate on the selected `SCENARIO`; use `make molecule-dependency` to resolve dependencies for all scenarios before running Molecule steps.

The current shared verifier reports that the role was applied; it does not assert role-specific system state. Add meaningful checks to `molecule/shared/verify.yml` as you implement your role. Keep tasks idempotent and test that behaviour with the full Molecule run.

## Template Setup

Before building on this template, review and replace the starter metadata in `meta/main.yml`, including the role name, author, description, licence, minimum Ansible version, supported platforms, and tags. Implement the role in `tasks/`, add defaults and handlers as required, and update the Molecule converge and verify playbooks for the behaviour you add.

`requirements.yml` is for role or collection dependencies needed by consumers. `molecule/shared/requirements.yml` contains collections used by the test scenarios. Python development tools are listed separately in `requirements-dev.txt`.

## CI

GitHub Actions runs `make lint` and runs the Molecule scenarios separately for Alpine and Debian. The workflow is configured for pushes and pull requests targeting `main`, `master`, or `develop`; see `.github/workflows/ci.yml` for the exact triggers and jobs.

## Troubleshooting

If a collection is missing, resolve test dependencies with:

```bash
make molecule-dependency
```

If Docker commands fail, check that Docker Engine is running and that your user can access its socket. To remove Molecule instances and generated test artefacts, run:

```bash
make clean
```

## Make Targets

Run `make help` to list the available targets. The project includes the following commands:

```bash
make help
make configure
make install
make requirements
make force-requirements
make ansible-lint
make yamllint
make lint
make test
make test-scenario SCENARIO=alpine
make molecule-dependency
make molecule-create SCENARIO=alpine
make molecule-converge SCENARIO=alpine
make molecule-verify SCENARIO=alpine
make molecule-destroy SCENARIO=alpine
make clean
```

Use `SCENARIO=<name>` with scenario-specific targets; the supported names are `alpine` and `debian`.
