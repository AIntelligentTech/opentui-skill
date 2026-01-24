# Security Policy

**Version:** 1.0
**Last Updated:** 2026-01-24
---

This repository contains **Claude Code skills** and a conservative installer script. While there is no server-side component, we still treat security and user safety seriously.

## Supported versions

The `VERSION` file at the repository root contains the canonical semantic version (for example, `0.1.0`).

As this project evolves, the maintainers will generally focus on the **latest minor version** for security-related fixes. Older versions may not receive backported patches.

## Reporting a vulnerability

If you believe you have found a security or privacy issue related to this toolkit:

1. **Do not** open a public GitHub issue describing the vulnerability in detail.
2. Instead, use one of the following channels (once the repo is hosted):
   - Open a private security advisory (if supported by the hosting platform), or
   - Contact the maintainers using the private contact method listed in the repository (e.g., SECURITY contact, GitHub security advisory, or similar).

When reporting, please include:

- A clear description of the issue and potential impact.
- Steps to reproduce, including any relevant configuration or environment details.
- Any suggested mitigations or workarounds, if known.

We aim to:

- Acknowledge receipt of your report in a reasonable timeframe.
- Investigate the issue and determine its severity.
- Prepare a fix or documented mitigation when appropriate.
- Coordinate disclosure timing if the issue is significant.

## Scope

Relevant vulnerabilities include (but are not limited to):

- Installer behavior that could accidentally modify files outside the intended `.claude/skills` directories.
- Skills or documentation that encourage unsafe shell usage or unreviewed code execution.
- Any behavior that could cause unexpected data loss or disclosure in typical usage.

Out of scope:

- Local misconfiguration of a user’s environment not related to this toolkit.
- Issues that require privileged local access to exploit (e.g., a malicious local user editing installed skills).

## Responsible disclosure

Please give maintainers reasonable time to address issues before public disclosure. Early, private reporting helps protect users while we develop and distribute fixes.
