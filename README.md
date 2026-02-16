# Dotfiles

Personal configuration files managed with GNU Stow for easy deployment and version control across Linux and macOS systems.

## ✨ Features

- 🚀 **Automated Installation** - Single script deployment with automatic OS detection
- 🔧 **Smart Package Management** - Auto-detects `apt`, `pacman`, or `brew` package managers
- 📦 **GNU Stow Integration** - Symlink-based configuration management
- 🔌 **Modular Setup Scripts** - Install only what you need
- 🍎 **Cross-Platform** - Works on Linux (Arch, Ubuntu, Debian) and macOS
- ⚡ **Go Tools Support** - Optional Go development tools installation
- 🎯 **Interactive Script Selector** - Choose which optional tools to install

## 📚 Prerequisites

### Required

- **Git** - Version control system
- **Homebrew** (macOS only) - [Installation Guide](https://brew.sh/)

### Auto-Detected

- **Package Managers**: `apt`, `pacman`, or `brew`
- **Operating Systems**: macOS (Darwin), Linux (Debian/Ubuntu/Arch)

## 🚀 Quick Start

### For Most Users (Complete Setup)

```bash
# Clone the repository
git clone https://github.com/GourangaDasSamrat/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Make executable and run
chmod +x scripts/install_tools.sh
./scripts/install_tools.sh
```

### For Advanced Users (Selective Installation)

```bash
# Clone the repository
git clone https://github.com/GourangaDasSamrat/dotfiles.git ~/dotfiles
cd ~/dotfiles/scripts

# Run interactive setup
chmod +x setup.sh
./setup.sh
```

## 📦 Installation Methods

### Method 1: Main Installer (Recommended)

The `install_tools.sh` script provides a complete, automated setup.

**What it installs:**

- Core development tools
- Shell enhancements (Oh My Zsh, plugins)
- Terminal multiplexer (Tmux + TPM)
- All dotfile configurations via GNU Stow

**Usage:**

```bash
cd ~/dotfiles
./scripts/install_tools.sh
```

### Method 2: Interactive Selector (Optional Tools)

The `setup.sh` script allows selective installation of optional components.

**Features:**

- Auto-discovery of available scripts
- Interactive numbered menu
- Multiple script selection
- Bulk execution support
- Detailed execution summary

**Usage:**

```bash
cd ~/dotfiles/scripts
./setup.sh

# Example selections:
# - Enter "1" for single script
# - Enter "1 3 5" for multiple scripts
# - Enter "all" for all scripts
```

## 📂 What's Included

### Core Tools (via `install_tools.sh`)

#### Common Tools (Both Linux & macOS)

| Tool          | Description                  | Use Case                       |
| ------------- | ---------------------------- | ------------------------------ |
| **Alacritty** | GPU-accelerated terminal     | Fast, modern terminal emulator |
| **Bat**       | Cat with syntax highlighting | Better file viewing            |
| **Eza**       | Modern ls replacement        | Enhanced directory listing     |
| **Starship**  | Cross-shell prompt           | Beautiful, fast prompt         |
| **Stow**      | Symlink farm manager         | Dotfile management             |
| **Tmux**      | Terminal multiplexer         | Split terminals, sessions      |

#### Linux-Specific Tools

| Tool                | Description                                                                                                                                               | Why Linux Only                            |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| **Zsh**             | Advanced shell                                                                                                                                            | macOS includes it by default              |
| **Rofi**            | Window switcher and application launcher                                                                                                                  | macOS has it's own spotlight search       |
| **Build essential** | Metapackage that provides a convenient way to install all the essential tools and libraries required for compiling and building software from source code | macOS don't have it, it's have xcode-tool |

#### Optional Tools (via `setup.sh`)

| Tool Category | Script                | Description                     |
| ------------- | --------------------- | ------------------------------- |
| **Go Tools**  | `install_go_tools.sh` | goimports, golangci-lint, gopls |

### Configurations

```
dotfiles/
├── alacritty/      # Terminal emulator config
├── git/            # Git config + custom hooks
├── rofi/           # Application launcher
├── tmux/           # Terminal multiplexer + TPM
├── vscode/         # Editor config + snippets
├── wallpapers/     # Curated wallpapers
└── zsh/            # Shell config + Starship
```

### Post-Installation Components

**Installed automatically:**

- **Oh My Zsh** - Zsh framework and plugin manager
- **TPM** - Tmux Plugin Manager
- **zsh-autosuggestions** - Fish-like autosuggestions
- **zsh-syntax-highlighting** - Command syntax validation

## 🎯 Advanced Usage

### Manual Stow Operations

```bash
# Install all configurations
cd ~/dotfiles
stow */

# Install specific packages
stow zsh tmux vscode

# Update after changes
stow -R zsh

# Remove configurations
stow -D tmux

# Dry run (see what would happen)
stow -n zsh
```

### Adding Tools to Installation

#### Add Common Tool (Both OS)

```bash
# Edit scripts/install_tools.sh
COMMON_TOOLS=("alacritty" "bat" "eza" "starship" "stow" "tmux" "neovim")
#                                                              ^^^^^^^^ new tool
```

#### Add OS-Specific Tool

```bash
# Linux only
LINUX_TOOLS=("zsh" "build-essential")
#                   ^^^^^^^^^^^^^^^^^ new tool

# macOS only
MACOS_TOOLS=("iterm2")
#            ^^^^^^^^ new tool
```

## 🙏 Acknowledgments

- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink farm manager
- [Oh My Zsh](https://ohmyz.sh/) - Zsh framework
- [Starship](https://starship.rs/) - Cross-shell prompt
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) - TPM
- [Alacritty](https://alacritty.org/) - GPU-accelerated terminal
- The open-source community for inspiration and tools

## 📞 Support

- 📧 **Email**: [gouranga.samrat@gmail.com](mailto:gouranga.samrat@gmail.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/GourangaDasSamrat/dotfiles/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/GourangaDasSamrat/dotfiles/discussions)
