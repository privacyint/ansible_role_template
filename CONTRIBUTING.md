# Contributing to this role

Thank you for considering contributing to this Ansible role.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:

   ```bash
   git clone https://github.com/YOUR-USERNAME/<><><>.git
   cd <><><>
   ```

3. **Create a feature branch**:

   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Guidelines

### Code Style

- Follow [Ansible best practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- Use British English in documentation
- Keep tasks idempotent
- Use meaningful variable names with the role prefix
- Include comments for complex logic

### Testing

Before submitting your changes:

1. **Syntax check**:

   ```bash
   ansible-playbook --syntax-check tests/test.yml
   ```

2. **Lint your code**:

   ```bash
   ansible-lint .
   ```

3. **Test on a clean system** (Debian 12/13 or Alpine Linux 3.x)

### Security

- **Never commit secrets** or sensitive data
- Use Ansible Vault for any example credentials
- Follow the principle of least privilege
- Review dependencies for known vulnerabilities

## Submitting Changes

1. **Commit your changes** with clear, concise messages:

   ```bash
   git commit -m "Add support for feature X"
   ```

2. **Push to your fork**:

   ```bash
   git push origin feature/your-feature-name
   ```

3. **Open a Pull Request** with:
   - Clear description of changes
   - Rationale for the change
   - Testing performed
   - Any breaking changes or migration notes

### Pull Request Checklist

- [ ] Code follows Ansible best practices
- [ ] Variables are documented in README.md
- [ ] Changes are tested on supported platforms
- [ ] Commit messages are clear and descriptive
- [ ] No secrets or sensitive data included
- [ ] Documentation updated if needed

## Reporting Issues

- Use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md) for bugs
- Use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.md) for new features
- For security vulnerabilities, see [SECURITY.md](SECURITY.md)

## Code of Conduct

Please note that this project adheres to a Code of Conduct (see [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)). By participating,
you are expected to uphold this code.

## Questions?

If you have questions about contributing, feel free to:

- Open a discussion issue
- Contact Privacy International at <tech@privacyinternational.org>

## Licence

By contributing to this project, you agree that your contributions will be licenced under the
[YOLO Public License (YPL) v0.12.34-hunter.2](LICENCE).
