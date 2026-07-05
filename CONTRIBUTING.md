# Contributing

First off, thanks for your interest! This is a small personal project opened to the community.

## Scope

This repo hosts [Noctalia 5+](https://noctalia.dev) plugins — primarily `rbw-launcher` (Bitwarden vault search via `rbw` CLI).

## Before You Open an Issue

- Check the [README](README.md) first — your question might already be answered
- Make sure `rbw` is installed and configured (`rbw config` + `rbw login`)
- Check if the issue persists after restarting Noctalia

## Reporting a Bug

Open a [bug report](https://github.com/vinnyduke/noctalia-v5-plugins/issues/new?template=bug_report.md) with:

- Your Noctalia version
- Your OS / desktop environment
- Steps to reproduce
- What you expected vs what happened
- Relevant logs or screenshots (if applicable)

## Feature Requests

Open a feature request in [Discussions](https://github.com/vinnyduke/noctalia-v5-plugins/discussions) first. Not everything fits a small plugin — expect honest scoping feedback.

## Pull Requests

1. Fork the repo
2. Create a branch (`feat/my-thing`, `fix/something`)
3. Keep changes focused — one PR = one thing
4. Use conventional commits (`feat:`, `fix:`, `chore:`, `docs:`)
5. Make sure the plugin still validates: `noctalia validate-plugin rbw-launcher`
6. Open the PR

## AI-Assisted Development

Parts of this codebase were developed with AI assistance (Claude Code). If you also use AI tooling, that's welcome — just be clear about it in your PR description so reviewers know what to look at carefully.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
