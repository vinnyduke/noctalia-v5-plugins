# Noctalia Plugins

Plugin monorepo for [Noctalia 5+](https://noctalia.dev). Each subdirectory is a plugin loaded directly from source — no build step.

## Plugins

| Plugin | Description |
|--------|-------------|
| [rbw-launcher](rbw-launcher/) | Search Bitwarden vault entries via rbw CLI (prefix `/rbw`) |

## Structure

```
├── catalog.toml            # Aggregated metadata (auto-generated)
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
```

`.luau` files are hot-reloaded on save.

## License

MIT — see [LICENSE](LICENSE) for details.
