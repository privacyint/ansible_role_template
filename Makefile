.PHONY: help configure install lint test test-scenario clean molecule-dependency molecule-create molecule-converge molecule-verify molecule-destroy

SCENARIO ?= alpine
export PATH := $(CURDIR)/.venv/bin:$(PATH)

help:
	@echo "Ansible Role Development Tasks"
	@echo ""
	@echo "Available targets:"
	@echo "  help                  Show this help message"
	@echo "  configure             Configure the development environment and install dependencies"
	@echo "  install               Install development dependencies"
	@echo "  lint                  Run ansible-lint and yamllint"
	@echo "  test                  Run full Molecule test suite"
	@echo '  test-scenario         Run one Molecule scenario (set `SCENARIO=<scenario>`)'
	@echo "  molecule-dependency   Resolve dependencies for all scenarios"
	@echo "  molecule-create       Create Molecule test instances"
	@echo "  molecule-converge     Apply role to test instances"
	@echo "  molecule-verify       Run verification tests"
	@echo "  molecule-destroy      Destroy Molecule test instances"
	@echo "  SCENARIO              Scenario for molecule-* targets"
	@echo "  clean                 Clean up test artifacts"

configure:
	@echo "Configuring the development environment..."
	python3.13 -m venv .venv
	.venv/bin/python -m pip install --upgrade pip
	$(MAKE) install

install:
	@echo "Installing development dependencies..."
	.venv/bin/python -m pip install -r requirements-dev.txt

lint:
	@echo "Running ansible-lint..."
	.venv/bin/ansible-lint --profile production
	@echo "Running yamllint..."
	.venv/bin/yamllint .

test:
	@echo "Running all Molecule scenarios..."
	.venv/bin/molecule test --all

test-scenario:
	@echo "Running the $(SCENARIO) Molecule scenario..."
	.venv/bin/molecule test --scenario-name "$(SCENARIO)"

molecule-create: molecule-dependency
	@echo "Creating $(SCENARIO) Molecule test instances..."
	.venv/bin/molecule create --scenario-name "$(SCENARIO)"

molecule-dependency:
	@echo "Resolving Molecule test requirements for all scenarios..."
	.venv/bin/molecule dependency --all

molecule-converge: molecule-dependency
	@echo "Applying role in the $(SCENARIO) scenario..."
	.venv/bin/molecule converge --scenario-name "$(SCENARIO)"

molecule-verify: molecule-dependency
	@echo "Running $(SCENARIO) verification tests..."
	.venv/bin/molecule verify --scenario-name "$(SCENARIO)"

molecule-destroy:
	@echo "Destroying $(SCENARIO) test instances..."
	.venv/bin/molecule destroy --scenario-name "$(SCENARIO)"

clean:
	@echo "Cleaning up test artifacts..."
	.venv/bin/molecule destroy --all
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	find . -type f -name "*.retry" -delete 2>/dev/null || true
	rm -rf .pytest_cache .molecule .cache 2>/dev/null || true
