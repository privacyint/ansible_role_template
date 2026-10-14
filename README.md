# Ansible Role Template

This repository is a starter template for building an Ansible role.

It includes the basic project structure, local development tooling, Molecule test scenarios, and GitHub Actions workflows
for linting, dependency checks, documentation checks, and release automation.

## Quick start

```bash
make configure
make lint
make test
```

## Development guide

See [DEVELOPMENT.md](DEVELOPMENT.md) for the full local workflow, project setup, troubleshooting, and CI documentation.

## Repository layout

- `defaults/` - default variables for the role
- `handlers/` - handler definitions
- `meta/` - role metadata
- `molecule/` - Molecule scenarios and shared test config
- `tasks/` - role tasks
- `.github/workflows/` - CI and automation workflows
