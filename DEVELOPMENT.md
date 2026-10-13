# Development Guide

This repository is a starter template for building an Ansible role.

The role implementation is intentionally empty: `tasks/main.yml` and `handlers/main.yml` are placeholders, and the
Molecule verifier currently checks only that the role can be included.

Adapt the role metadata, defaults, tasks, and verification to your use case before relying on it to manage a system.
You may want to also update this file to at least reference your new role, as it describes how our `Makefile` works
and will be useful for future developers on your role.

## Prerequisites

- Python 3.13
- Docker Engine available to the current user, with the daemon running
- GNU Make
- NodeJS 20 (if and only if you want to run `make markdownlint`, including via the `make lint` target)

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

This creates `.venv` with Python 3.13, installs the development dependencies from `requirements-dev.txt`, installs
role dependencies from `requirements.yml`, and resolves Molecule dependencies for all scenarios. Roles are installed
in `.ansible/roles` and collections in `.ansible/collections`; the Makefile exports these paths for Ansible and
Molecule commands. It invokes development tools from `.venv/bin`, so activating the virtual environment is not
required when using its targets.

To install only the Python development tools, use:

```bash
make install
```

To install role dependencies explicitly, use:

```bash
make requirements
```

To force reinstall dependencies (e.g. you have changed a version of a SHA pinned role), you can run:

```bash
make force-requirements
```

## Lint

Run all three configured linters:

```bash
make lint
```

To run them directly:

```bash
make ansible-lint
make markdownlint
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

The template scenarios use Alpine 3.24 and Debian Trixie Docker images, with a real init.

Make discovers scenario names from `molecule/*/molecule.yml`.

If unsupplied, `SCENARIO` defaults to the first globbed name (currently `alpine`). Set it explicitly to run another
scenario or to work through individual Molecule stages:

```bash
make test-scenario SCENARIO=debian
make molecule-create SCENARIO=alpine
make molecule-converge SCENARIO=alpine
make molecule-verify SCENARIO=alpine
make molecule-destroy SCENARIO=alpine
```

The `molecule-*` targets operate on the selected `SCENARIO`; use `make molecule-dependency` to resolve dependencies for
all scenarios before running Molecule steps.

The current shared verifier reports that the role was applied; it does not assert role-specific system state. Add meaningful
behavioural checks to `molecule/shared/verify.yml` as you implement your role; it is uninteresting that files match what
we expect, but we want to know that, for instance a webserver is up and serving what we expect it to be rather than throwing
an error.

Keep tasks idempotent and test that behaviour with the full Molecule run.

## Template Setup

Before building on this template, review and replace the starter metadata in `meta/main.yml`, including the role name, author,
description, licence, minimum Ansible version, supported platforms, and tags.

Implement the role in `tasks/`, add defaults and handlers as required, and update the Molecule converge and verify playbooks
for the behaviour you add.

`requirements.yml` is for role or collection dependencies needed by consumers. `molecule/shared/requirements.yml` contains
collections used by the test scenarios. Python development tools are listed separately in `requirements-dev.txt`.

## CI

The repository uses GitHub Actions for the main development checks and for routine dependency maintenance.

- `.github/workflows/ci.yml` runs the base Ansible checks (`make ansible-lint` and `make yamllint`) and the Molecule scenarios.
- `.github/workflows/docs.yml` runs the Markdown linting checks for repository documentation.
- `.github/workflows/security-and-dependencies.yml` performs dependency and security checks.
- `.github/workflows/release.yml` handles release publication for tagged builds.

The local `make lint` target combines `ansible-lint`, `yamllint`, and `markdownlint`, but the CI workflows split that work
across separate jobs so the Markdown checks are not part of the core Molecule validation job.

The scheduled dependency bump workflows are documented in the next section because they are intentionally operational and
review-oriented rather than part of the normal validation path.

## Troubleshooting

If a collection is missing, resolve test dependencies with:

```bash
make molecule-dependency
```

If Docker commands fail, check that Docker Engine is running and that your user can access its socket. To remove Molecule
instances and generated test artefacts, run:

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
make markdownlint
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

Use `SCENARIO=<name>` with scenario-specific targets. Run `make help` to see the discovered scenario names and which one
is the current default.

## Dependency bump workflows

The repository includes two scheduled GitHub Actions workflows that keep dependency pins current without doing a blind bulk
update:

- `.github/workflows/bump-github-actions.yml` checks upstream GitHub Action releases, resolves the newest tag SHA, and
  opens a separate pull request for each action that has advanced.
- `.github/workflows/bump-ansible-requirements.yml` does the same for GitHub-hosted role dependencies in
  `requirements.yml`, comparing the current pinned SHA against the upstream release tag SHA and updating the pinned value.

Both workflows run on a weekly schedule and can also be started manually with `workflow_dispatch`. They resolve the
repository default branch before opening the PR so the update lands on the right base branch, and each PR title names the
specific dependency or action being bumped. The PR description includes the upstream tag and the target commit link so a
human reviewer can inspect exactly what has changed before merging.

The workflows expect a `BUMP_PR_TOKEN` repository secret to exist so `peter-evans/create-pull-request` can open the PRs.
This keeps updates reviewable, reduces the risk of merging an unexpected upstream change, and makes it easier to approve
or reject a single dependency bump without coupling it to unrelated updates.
