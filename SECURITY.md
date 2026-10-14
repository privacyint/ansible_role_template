# Security Policy

## Reporting a Vulnerability

Privacy International takes security issues seriously.

If you discover a security vulnerability in this Ansible role, please report it responsibly.

### How to Report

**Do not** open a public GitHub issue for security vulnerabilities.

Instead, please report security issues to:

**Email**: <tech@privacyinternational.org>

Include the following information in your report:

- A description of the vulnerability
- Steps to reproduce the issue
- Potential impact
- Any suggested fixes (optional)

### What to Expect

- **Acknowledgement**: We will acknowledge receipt of your report within 3 working days
- **Assessment**: We will assess the vulnerability and determine its severity
- **Resolution**: We will work to address the issue and will keep you informed of our progress
- **Disclosure**: Once a fix is available, we will coordinate responsible disclosure with you

### Security Best Practices

When using this role:

- Always use Ansible Vault or similar tools to encrypt sensitive variables (passwords, secrets, API keys)
- Review the role's tasks and templates before deployment
- Keep dependencies up to date
- Follow the principle of least privilege for service accounts
- Enable TLS/SSL for all network communications
- Regularly audit your logs for suspicious activity

### Supported Versions

We provide security updates for the latest version of this role. If you are using an older version, please update to the
latest release.

## Additional Resources

- [Privacy International Website](https://privacyinternational.org/)
