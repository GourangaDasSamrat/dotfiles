# Zsh Configuration Documentation

This directory contains documentation for the complete Zsh shell configuration setup.

## Overview

The Zsh configuration is organized into modular components:

### Core Configuration

- [`architecture.md`](architecture.md) - ZSH startup flow, module loading, `.zshenv` vs `.zshrc`
- [`core.md`](core.md) - Environment variables, history behavior, shell options, colors
- [`customization.md`](customization.md) - Starship prompt, aliases, overrides, user customizations

### Functions (`.config/zsh/functions/`)

- [`functions.md`](functions.md) - Custom shell utilities for archives, networking, API requests, security, automation, and productivity helpers

### Plugins (`.config/zsh/plugins/`)

- [`plugins.md`](plugins.md) - External integrations and plugin configuration (`fzf`, `pass`, and related tooling)

## Architecture

```
~/.config/zsh/
├── .zshrc                 # Entry point, loads all modules
├── .config/
│   ├── starship.toml     # Prompt configuration
│   └── zsh/
│       ├── core/         # Core configuration modules
│       ├── functions/    # Custom functions
│       ├── plugins/      # Plugin configurations
│       └── user/         # User customizations
└── ~/.zshenv             # Environment setup (ZDOTDIR override)
```

## Loading Order

The ZSH configuration loads modules in this specific order:

1. **Core Environment** (`core/env.zsh`) - Sets up PATH and tool configurations
2. **Colors** (`core/colors.zsh`) - Initializes color system
3. **History** (`core/history.zsh`) - Configures command history
4. **Utility Functions** (`functions/utils.zsh`) - General utilities
5. **Archive Functions** (`functions/archive.zsh`) - Compression/extraction
6. **Directory Hooks** (`functions/chpwd.zsh`) - Auto-activation on cd
7. **FZF Plugin** (`plugins/fzf.zsh`) - Fuzzy finder
8. **Pass Plugin** (`plugins/pass.zsh`) - Password manager
9. **User Aliases** (`user/aliases.zsh`) - Command shortcuts
10. **Security Functions** (`functions/security.zsh`) - GPG utilities
11. **User Overrides** (`user/overrides.zsh`) - Custom command implementations
12. **Whois Functions** (`functions/whois.zsh`) - Domain info lookup
13. **Network Functions** (`functions/network.zsh`) - Network utilities

## Key Features

### 🔒 Security

- **Credential Protection**: Sensitive commands filtered from history
- **GPG Integration**: Auto-locking vault every 15 minutes
- **Environment Secrets**: Secure `.zsh_secrets` file loading

### 🎨 Customization

- **Universal Color Palette**: Consistent colors across all components
- **Starship Prompt**: Minimal, fast, and infinitely customizable
- **Theme Support**: Dracula and Catppuccin themes for FZF

### 🚀 Developer Experience

- **Smart Tool Detection**: Auto-detection of project files (Justfile, Makefile, package.json)
- **Auto Virtual Env**: Automatic Python venv activation/deactivation
- **Interactive Functions**: FZF-based UI for complex operations (API requests, compression)

### 📦 Tool Support

- **Language Tools**: Go, Rust, Python, Lua, C/C++
- **Package Managers**: npm/pnpm, Cargo, Homebrew
- **CLI Tools**: Docker, Git, usql, pass

## Quick Start

### Reload Configuration

```bash
reload
```

### Essential Functions

**Server**

```bash
serve 8080     # Start Python HTTP server on port 8080
```

**Timer**

```bash
timer 5m30s    # Set timer for 5 minutes 30 seconds
```

**Archive Operations**

```bash
extract file.tar.gz
compress my_folder
```

**API Requests**

```bash
apireq         # Interactive API request builder
```

**Network Info**

```bash
isup example.com
myip           # Show public IP info
inspect example.com  # SSL certificate and headers
```

**Domain Lookup**

```bash
dzw example.com
dzw dp example.com  # Via specific server
```

### Aliases by Category

**VS Code Profiles**

```bash
code-r         # Rust Dev profile
code-g         # Go Dev profile
```

**Cargo**

```bash
cr             # cargo run
cb             # cargo build
ct             # cargo test
```

**Eza (ls replacement)**

```bash
ls             # Enhanced ls with git status
lt             # Tree view with colors
```

## Dependencies

### Required

- `zsh` - Shell
- `oh-my-zsh` - Plugin framework
- `git` - Version control
- `fzf` - Fuzzy finder
- `fd` - Faster find

### Recommended

- `eza` - Modern ls replacement
- `bat` - Syntax-highlighted cat
- `starship` - Cross-shell prompt
- `httpie` - HTTP client (for network functions)
- `pass` - Password manager
- `jq` - JSON processor
- `python3` - HTTP server, API request validation

### Optional

- `gpg` - GPG encryption/decryption
- `docker` - Container management
- `cargo` - Rust toolchain
- `go` - Go toolchain
- `npm`/`pnpm` - Node package managers

## Troubleshooting

### Missing Module Warning

If you see `⚠️ missing: $file`, ensure the module exists and permissions are correct.

### History Not Saved

Check `~/.zsh_history` file permissions and available disk space.

### Colors Not Showing

Ensure your terminal supports 256 colors: `echo $TERM` (should be `xterm-256color` or similar)

### FZF Preview Not Working

Install required tools:

```bash
# eza for directory preview
# bat for file preview
```

## Configuration Files Reference

| File                        | Purpose                   |
| --------------------------- | ------------------------- |
| `~/.zshenv`                 | ZDOTDIR override          |
| `~/.config/zsh/.zshrc`      | Main config loader        |
| `~/.config/zsh/core/*`      | Core modules              |
| `~/.config/zsh/functions/*` | Custom functions          |
| `~/.config/zsh/plugins/*`   | Plugin configs            |
| `~/.config/zsh/user/*`      | User customizations       |
| `~/.config/starship.toml`   | Starship prompt           |
| `~/.zsh_secrets`            | Local secrets (600 perms) |
| `~/.zsh_history`            | Command history           |

## Learn More

Each component has detailed documentation in its respective file. Start with the specific area you want to understand or customize.
