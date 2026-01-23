# Dotfiles

Personal configuration files managed with GNU Stow for easy deployment and version control.

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- Git

Install Stow:
```bash
# Arch Linux
sudo pacman -S stow

# Ubuntu/Debian
sudo apt install stow

# macOS
brew install stow
```

## Installation

1. Clone this repository to your home directory:
```bash
git clone <repository-url> ~/dotfiles
cd ~/dotfiles
```

2. Deploy all configurations:
```bash
stow */
```

Or deploy specific packages:
```bash
stow zsh
stow tmux
stow vscode
stow rofi
```

## Package Details

### Rofi
Application launcher configuration with custom styling.
- **Location:** `~/.config/rofi/config.rasi`

### Tmux
Terminal multiplexer configuration for enhanced productivity.
- **Location:** `~/.tmux.conf`

### VS Code (Code - OSS)
Complete VS Code setup including:
- Custom settings and keybindings
- C++ code snippets
- Extension list available in `docs/extensions-list.md`
- **Location:** `~/.config/Code - OSS/User/`

### Zsh
Comprehensive shell configuration with modular design:
- **Starship prompt** - Modern, fast prompt with Git integration
- **Custom utilities** - Archive management, color schemes, weather info
- **Modular structure** - Organized configuration files for easy maintenance
- **Locations:**
  - `~/.zshrc` - Main configuration
  - `~/.config/zsh/` - Modular config files
  - `~/.config/starship.toml` - Prompt configuration

## Managing Configurations

### Update configurations
After modifying any configuration files:
```bash
stow -R <package-name>

# Example: Restow zsh after changes
stow -R zsh
```

### Remove configurations
To unlink specific configurations:
```bash
stow -D <package-name>

# Example: Remove tmux symlinks
stow -D tmux
```

### Remove all configurations
```bash
stow -D */
```

## Notes

- All configurations are symlinked to maintain a single source of truth
- The `.stow-local-ignore` file prevents documentation and metadata files from being symlinked
- Reference files and documentation are kept in the `docs/` directory
- Backup your existing configurations before deployment

## License

MIT License - See [LICENSE](LICENSE) file for details.