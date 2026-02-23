# Dotfiles

Personal configuration files managed with GNU Stow for easy deployment and version control across Linux and macOS systems.

## ✨ Features

- 🚀 **Automated Installation** — Single script deployment with automatic OS detection
- 🔧 **Smart Package Management** — Auto-detects `apt`, `pacman`, or `brew`
- 📦 **GNU Stow Integration** — Symlink-based configuration management
- 🔌 **Modular Setup Scripts** — Install only what you need via interactive selector
- 🍎 **Cross-Platform** — Linux (Arch, Ubuntu, Debian) and macOS
- ⚡ **Go Tools Support** — Optional Go development environment setup
- 🎯 **Standalone Scripts** — Every lib script runs independently or as part of full install

## 📚 Prerequisites

### Required

- **Git** — Version control system
- **Homebrew** (macOS only) — [Installation Guide](https://brew.sh/)

### Auto-Detected

- **Package Managers**: `apt`, `pacman`, or `brew`
- **Operating Systems**: macOS (Darwin), Linux (Debian/Ubuntu/Arch)

## 🚀 Quick Start

### Complete Setup

```bash
git clone https://github.com/GourangaDasSamrat/dotfiles.git ~/dotfiles
cd ~/dotfiles/scripts

chmod +x install.sh
./install.sh
```

### Selective Installation

```bash
cd ~/dotfiles/scripts

chmod +x setup.sh
./setup.sh
```

## 📂 Repository Structure

```
dotfiles/
├── alacritty/                        # Terminal emulator config
│   └── .config/alacritty/
│       ├── alacritty.toml
│       └── themes/dracula.toml
├── docs/
│   └── vscode-extensions.md          # Recommended VS Code extensions
├── git/                              # Git config + custom hooks
│   ├── .git-hooks/commit-msg
│   └── .gitconfig
├── rofi/                             # Application launcher config
│   └── .config/rofi/config.rasi
├── scripts/
│   ├── install.sh                    # Full automated setup
│   ├── setup.sh                      # Interactive script selector
│   ├── lib/
│   │   ├── packages.sh               # Tool installation (sources detect.sh internally)
│   │   ├── plugins.sh                # Oh My Zsh, TPM, Zsh plugins
│   │   ├── wallpapers.sh             # Clone + rename wallpapers
│   │   ├── dotfiles.sh               # Stow symlinks + git hooks
│   │   └── go_tools.sh               # Optional Go dev tools
│   └── utils/
│       └── detect.sh                 # OS, package manager, sudo detection
├── tmux/
│   └── .tmux.conf                    # Tmux config + TPM plugins
├── vscode/
│   └── .config/Code - OSS/User/
│       ├── settings.json
│       ├── keybindings.json
│       └── snippets/
│           ├── cpp.json
│           ├── go.json
│           ├── clang-format.code-snippets
│           └── react-components.code-snippets
└── zsh/
    ├── .zshrc
    └── .config/
        ├── starship.toml             # Starship prompt config
        └── zsh/
            ├── archive.zsh           # Archive helper functions
            ├── apireq.zsh           # Api request client using curl
            ├── colors.zsh            # Terminal color aliases and fzf themes
            ├── overrides.zsh         # Custom overrides
            ├── utils.zsh             # General utility functions
            └── weather.zsh           # Weather in terminal
```

## 📦 Installation Methods

### Method 1: Full Install (`install.sh`)

Runs all lib scripts in sequence — packages, plugins, wallpapers, dotfiles.

```bash
cd ~/dotfiles/scripts
./install.sh
```

### Method 2: Interactive Selector (`setup.sh`)

Scans all `.sh` files across subdirectories (excluding `utils/`) and lets you pick what to run.

```bash
cd ~/dotfiles/scripts
./setup.sh

# Enter "1" for a single script
# Enter "1 3 5" for multiple scripts
# Enter "all" to run everything
```

### Method 3: Run Any Script Standalone

Every script in `lib/` is self-contained and can be run independently.

```bash
# Install packages only
bash scripts/lib/packages.sh

# Set up Zsh plugins only
bash scripts/lib/plugins.sh

# Clone and rename wallpapers only
bash scripts/lib/wallpapers.sh

# Run stow only
bash scripts/lib/dotfiles.sh

# Install Go tools only
bash scripts/lib/go_tools.sh
```

## 🔧 Script Architecture

```
utils/detect.sh
    └── sourced by → lib/packages.sh (and any future script that needs it)

lib/packages.sh   → installs core tools
lib/plugins.sh    → Oh My Zsh, TPM, zsh-autosuggestions, zsh-syntax-highlighting
lib/wallpapers.sh → clones ~/Pictures/wallpapers
lib/dotfiles.sh   → runs stow, sets git hook permissions
lib/go_tools.sh   → optional: goimports, golangci-lint, gopls

install.sh        → sources and runs all of the above in order
setup.sh          → interactive menu, discovers scripts in subdirs (utils/ excluded)
```

`detect.sh` exports `$OS`, `$PKG_MANAGER`, and `$SUDO_CMD`. Any script can `source utils/detect.sh` to use these variables without duplicating detection logic.

## 🛠️ Core Tools Installed

### Common (Linux + macOS)

| Tool          | Description                       |
| ------------- | --------------------------------- |
| **Alacritty** | GPU-accelerated terminal emulator |
| **Bat**       | `cat` with syntax highlighting    |
| **Eza**       | Modern `ls` replacement           |
| **Starship**  | Cross-shell prompt                |
| **Stow**      | Symlink farm manager              |
| **Tmux**      | Terminal multiplexer              |
| **jq**        | JSON processor                    |
| **fzf**       | Fuzzy finder                      |
| **fd**        | `find` with extra speed           |

### Linux-Only

| Tool                | Reason                         |
| ------------------- | ------------------------------ |
| **Zsh**             | macOS ships with it by default |
| **Rofi**            | macOS has Spotlight            |
| **build-essential** | macOS uses Xcode tools         |

### Post-Install (Automatic)

- **Oh My Zsh** — Zsh framework
- **TPM** — Tmux Plugin Manager
- **zsh-autosuggestions** — Fish-like autosuggestions
- **zsh-syntax-highlighting** — Command syntax validation

### Optional (via `go_tools.sh`)

- `goimports`, `golangci-lint`, `gopls`

## 🎯 Manual Stow Operations

```bash
cd ~/dotfiles

# Symlink all configs
stow */

# Symlink specific packages
stow zsh tmux vscode alacritty

# Re-apply after changes
stow -R zsh

# Remove symlinks
stow -D tmux

# Dry run
stow -n zsh
```

## ➕ Adding New Tools

```bash
# Add to both OS
COMMON_TOOLS=("alacritty" "bat" "eza" "starship" "stow" "tmux" "new-tool")

# Linux only
LINUX_TOOLS=("zsh" "build-essential" "rofi" "new-tool")

# macOS only
MACOS_TOOLS=("iterm2")
```

## 🙏 Acknowledgments

- [GNU Stow](https://www.gnu.org/software/stow/) — Symlink farm manager
- [Oh My Zsh](https://ohmyz.sh/) — Zsh framework
- [Starship](https://starship.rs/) — Cross-shell prompt
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) — TPM
- [Alacritty](https://alacritty.org/) — GPU-accelerated terminal

## 📞 Support

- 📧 **Email**: [gouranga.samrat@gmail.com](mailto:gouranga.samrat@gmail.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/GourangaDasSamrat/dotfiles/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/GourangaDasSamrat/dotfiles/discussions)
