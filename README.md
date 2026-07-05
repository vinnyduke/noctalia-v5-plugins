# Noctalia Plugins

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Noctalia](https://img.shields.io/badge/Noctalia-5.0+-blue)](https://noctalia.dev)
[![CI](https://github.com/vinnyduke/noctalia-v5-plugins/actions/workflows/validate.yml/badge.svg)](https://github.com/vinnyduke/noctalia-v5-plugins/actions/workflows/validate.yml)

Plugin monorepo for [Noctalia 5+](https://noctalia.dev). Each subdirectory is a plugin loaded directly from source — no build step.

## Plugins

| Plugin | Description |
|--------|-------------|
| [rbw-launcher](rbw-launcher/) | Search Bitwarden vault entries via rbw CLI (prefix `/rbw`) |

## Structure

```
├── catalog.toml            # Aggregated metadata (auto-generated)
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── .gitignore
├── LICENSE
├── README.md
└── <plugin>/
    ├── plugin.toml         # Plugin manifest (required)
    ├── launcher.luau       # Launcher provider (optional)
    ├── assets/             # Images / screenshots
    └── translations/       # i18n files (en.json, fr.json, ...)
```

## Adding a New Plugin

1. Create `new-plugin/plugin.toml` with metadata + entry declarations
2. Create entry files
3. Optionally add `translations/`, `assets/`
4. Update `.gitignore` if needed
5. Regenerate catalog (see `catalog.toml` header)

## Development

```bash
# Validate plugin manifest
noctalia validate-plugin rbw-launcher

# Luau static analysis
luau-analyze --defs noctalia.d.luau rbw-launcher/launcher.luau
```

`.luau` files are hot-reloaded on save.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines, bug reports, and pull request process.

## AI Disclosure

Parts of this codebase were developed with AI assistance (Claude Code). AI tooling is welcome in contributions — just mention it in your PR description. All contributions, AI-assisted or not, are reviewed with the same standards.

## License

MIT — see [LICENSE](LICENSE) for details.
