.PHONY: help configure install requirements force-requirements ansible-lint yamllint markdownlint lint test test-scenario clean molecule-dependency molecule-create molecule-converge molecule-verify molecule-destroy
SCENARIOS := $(patsubst molecule/%/molecule.yml,%,$(wildcard molecule/*/molecule.yml))
SCENARIO ?= $(firstword $(SCENARIOS))
PYTHON := python3.13
MARKDOWNLINT := 0.22.1
VENV_PATH := $(CURDIR)/.venv
ANSIBLE_PATH := $(CURDIR)/.ansible
export PATH := $(VENV_PATH)/bin:$(PATH)
export ANSIBLE_ROLES_PATH := $(ANSIBLE_PATH)/roles
export ANSIBLE_COLLECTIONS_PATH := $(ANSIBLE_PATH)/collections

help:
	@echo "Ansible Role Development Tasks"
	@echo ""
	@echo "Available targets:"
	@echo "  help                  Show this help message"
	@echo "  configure             Configure the development environment and install role and molecule dependencies"
	@echo "  install               Install development dependencies"
	@echo "  requirements          Install role dependencies from requirements.yml"
	@echo "  force-requirements    Force install role dependencies from requirements.yml (ignoring any cached versions)"
	@echo "  ansible-lint          Run ansible-lint"
	@echo "  yamllint              Run yamllint"
	@echo "  markdownlint          Run markdownlint on Markdown files"
	@echo "  lint                  Run ansible-lint, yamllint and markdownlint"
	@echo "  test                  Run full Molecule test suite"
	@echo '  test-scenario         Run one Molecule scenario (set `SCENARIO=<scenario>`)'
	@echo "  molecule-dependency   Resolve dependencies for all scenarios"
	@echo "  molecule-create       Create Molecule test instances"
	@echo "  molecule-converge     Apply role to test instances"
	@echo "  molecule-verify       Run verification tests"
	@echo "  molecule-destroy      Destroy Molecule test instances"
	@echo "  SCENARIO              Scenario for molecule-* targets. Defaults to $(SCENARIO). (available: $(SCENARIOS))"
	@echo "  clean                 Clean up test artifacts"

configure:
	@echo "Configuring the development environment..."
	$(PYTHON) -m venv $(VENV_PATH)
	$(VENV_PATH)/bin/python -m pip install --upgrade pip
	$(MAKE) install
	$(MAKE) requirements
	$(MAKE) molecule-dependency

install:
	@echo "Installing development dependencies..."
	$(VENV_PATH)/bin/python -m pip install -r requirements-dev.txt

requirements:
	@echo "Installing role dependencies from requirements.yml..."
	$(VENV_PATH)/bin/ansible-galaxy install -r requirements.yml --roles-path $(ANSIBLE_PATH)/roles
	$(VENV_PATH)/bin/ansible-galaxy collection install -r requirements.yml -p $(ANSIBLE_PATH)/collections

force-requirements: 
	@echo "Force installing role dependencies from requirements.yml..."
	$(VENV_PATH)/bin/ansible-galaxy install -r requirements.yml --roles-path $(ANSIBLE_PATH)/roles --force
	$(VENV_PATH)/bin/ansible-galaxy collection install -r requirements.yml -p $(ANSIBLE_PATH)/collections --force

ansible-lint:
	@echo "Running ansible-lint..."
	$(VENV_PATH)/bin/ansible-lint --profile production

yamllint:
	@echo "Running yamllint..."
	$(VENV_PATH)/bin/yamllint .

markdownlint:
	node -v || { echo "Node.js is not installed"; exit 1; }
	@echo "Running markdownlint..."
	find . \( -path './.venv' -o -path './.ansible' -o -path './.git' \) -prune -o -name '*.md' -exec npx --yes markdownlint-cli2@$(MARKDOWNLINT) {} +

lint: ansible-lint yamllint markdownlint

test:
	@echo "Running all Molecule scenarios..."
	$(VENV_PATH)/bin/molecule test --all

test-scenario:
	@echo "Running the $(SCENARIO) Molecule scenario..."
	$(VENV_PATH)/bin/molecule test --scenario-name "$(SCENARIO)"

molecule-create:
	@echo "Creating $(SCENARIO) Molecule test instances..."
	$(VENV_PATH)/bin/molecule create --scenario-name "$(SCENARIO)"

molecule-dependency:
	@echo "Resolving Molecule test requirements for all scenarios..."
	$(VENV_PATH)/bin/ansible-galaxy collection install --no-cache -r molecule/shared/requirements.yml -p $(ANSIBLE_PATH)/collections
	$(VENV_PATH)/bin/molecule dependency --all

molecule-converge:
	@echo "Applying role in the $(SCENARIO) scenario..."
	$(VENV_PATH)/bin/molecule converge --scenario-name "$(SCENARIO)"

molecule-verify:
	@echo "Running $(SCENARIO) verification tests..."
	$(VENV_PATH)/bin/molecule verify --scenario-name "$(SCENARIO)"

molecule-destroy:
	@echo "Destroying $(SCENARIO) test instances..."
	$(VENV_PATH)/bin/molecule destroy --scenario-name "$(SCENARIO)"

clean:
	@echo "Cleaning up test artifacts..."
	$(VENV_PATH)/bin/molecule destroy --all
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	find . -type f -name "*.retry" -delete 2>/dev/null || true
	rm -rf .pytest_cache .molecule .cache 2>/dev/null || true
