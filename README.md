# Dotfiles

Personal configuration files managed with GNU Stow for easy deployment and version control across Linux and macOS systems.

## Features

- 🚀 **Automated Installation** - Single script deployment with automatic OS detection
- 🔧 **Smart Package Management** - Auto-detects `apt` or `pacman` package managers
- 📦 **GNU Stow Integration** - Symlink-based configuration management
- 🔌 **Modular Setup Scripts** - Install only what you need
- 🍎 **Cross-Platform** - Works on Linux (Arch, Ubuntu, Debian) and macOS
- ⚡ **Go Tools Support** - Optional Go development tools installation

## Quick Start

### Prerequisites

- **Git** (required)
- **Homebrew** (required for macOS users)
- System will auto-detect and work with:
  - Package managers: `apt`, `pacman`, or `brew`
  - Operating systems: macOS, Linux

### Installation

#### Option 1: Quick Install (Recommended for Most Users)

For users who just want to install tools and stow dotfiles:

```bash
# Clone the repository to your home directory
git clone https://github.com/GourangaDasSamrat/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Make the script executable and run
chmod +x scripts/install_tools.sh
./scripts/install_tools.sh
```

This will:
- Detect your operating system automatically
- Install required tools and dependencies (using `apt`, `pacman`, or `brew`)
- Configure all dotfiles using GNU Stow
- Complete the main setup automatically

#### Option 2: Selective Script Execution

For users who want to run specific one-time scripts (like Go tools installation or future additions):

```bash
# Clone the repository
git clone https://github.com/GourangaDasSamrat/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Make setup script executable
chmod +x scripts/setup.sh

# Run the interactive setup
./scripts/setup.sh
```

The `setup.sh` script will:
- Scan and list all available installation scripts (e.g., `install_go_tools.sh`)
- Display them with serial numbers for selection
- Let you choose which scripts to run
- You can select specific scripts by number or run all at once

**Example workflow:**
```bash
./scripts/setup.sh

# Output shows:
# 1. install_go_tools.sh
# 2. install_additional_tools.sh
# ...
# Enter numbers (space-separated) or 'all':

# Run specific scripts:
1 3

# Or run everything:
all
```

## Understanding the Installation Scripts

### `install_tools.sh` - Main Installation Script

This is your **primary installer** for everyday use. It handles:
- Core tool installation (Git, Stow, etc.)
- Dotfile deployment via GNU Stow
- Essential configuration setup
- Cross-platform compatibility (auto-detects apt/pacman/brew)

**Use this if:** You want a quick, complete setup of your dotfiles.

### `setup.sh` - Selective Script Manager

This is for **optional and one-time installations**. It provides:
- Interactive menu of available scripts
- Selective execution of additional tools
- Currently includes `install_go_tools.sh` for Go development tools
- Future-proof for additional tool scripts

**Use this if:** You want to install optional components like Go tools or run specific scripts.

### Available Optional Scripts

- **`install_go_tools.sh`** - Installs Go development tools and utilities
- *More scripts can be added in the future*

## Advanced Usage

### Running Setup Scripts Interactively

```bash
# Make setup.sh executable
chmod +x scripts/setup.sh

# List all available optional installation scripts
./scripts/setup.sh

# Run specific scripts by their serial numbers (space-separated)
./scripts/setup.sh 1 3 5

# Run all optional scripts automatically
./scripts/setup.sh all
```

The setup script will:
- Automatically set proper permissions for all scripts
- Execute selected scripts in order
- Handle errors gracefully

### Manual Stow Operations

If you prefer manual control:

```bash
# Install all configurations
stow */

# Install specific packages
stow zsh
stow tmux
stow vscode

# Update configurations after changes
stow -R <package-name>

# Remove specific configurations
stow -D <package-name>
```

## What's Included

### Configurations

- **Alacritty** - Modern terminal emulator configuration
- **Git** - Version control settings
- **Rofi** - Application launcher with custom styling
- **Tmux** - Terminal multiplexer for enhanced productivity
- **VS Code** - Complete editor setup with snippets and keybindings
- **Wallpapers** - Curated wallpaper collection
- **Zsh** - Comprehensive shell configuration with:
  - Starship prompt integration
  - Custom utilities and functions
  - Modular configuration structure
  - Archive management tools
  - Color schemes
  - Weather info utilities

### Scripts

Located in the `scripts/` directory:

- **`install_tools.sh`** - Main installer for tools and dotfiles (recommended for most users)
- **`setup.sh`** - Interactive script manager for optional installations
- **`install_go_tools.sh`** - Go development tools installer (optional)
- Additional tool-specific installation scripts (extensible)

## Directory Structure

```
~/dotfiles/
├── alacritty/          # Terminal emulator config
├── git/                # Git configuration
├── rofi/               # Application launcher
├── scripts/            # Installation and setup scripts
│   ├── install_tools.sh      # Main installer (tools + dotfiles)
│   ├── setup.sh              # Interactive optional script manager
│   └── install_go_tools.sh   # Go tools installer (optional)
├── tmux/               # Terminal multiplexer
├── vscode/             # Editor configuration
├── wallpapers/         # Wallpaper collection
├── zsh/                # Shell configuration
└── docs/               # Documentation and references
```

## File Locations

After installation, configurations are symlinked to:

- `~/.config/` - Primary config directory
- `~/.zshrc` - Shell configuration
- `~/.tmux.conf` - Tmux configuration
- `~/.gitconfig` - Git configuration

## Customization

### Adding New Configurations

1. Create a new directory in the repository root
2. Organize files matching your home directory structure
3. Run `stow <directory-name>` to deploy

### Modifying Existing Configs

1. Edit files in the repository
2. Run `stow -R <package-name>` to update symlinks
3. Changes reflect immediately in your system

## Troubleshooting

### Permission Issues

```bash
# Grant execution permission to scripts
chmod +x scripts/install_tools.sh
chmod +x scripts/setup.sh
```

### Conflicting Files

If you have existing configurations:

```bash
# Backup existing configs
mv ~/.zshrc ~/.zshrc.backup
mv ~/.tmux.conf ~/.tmux.conf.backup

# Then run the installer
./scripts/install_tools.sh
```

### Package Manager Not Detected

The system automatically detects `apt`, `pacman`, or `brew`. If you're using a different package manager, you may need to install dependencies manually:

- **macOS users:** Install [Homebrew](https://brew.sh/) first
- **Linux users:** System works with apt (Debian/Ubuntu) or pacman (Arch)

## System Requirements

- **Git** - Required for cloning and version control
- **Homebrew** - Required for macOS users ([Install here](https://brew.sh/))
- **GNU Stow** - Automatically installed by the `install_tools.sh` script
- **Operating System** - Linux or macOS
- **Package Manager** - apt (Debian/Ubuntu), pacman (Arch), or brew (macOS)

## Usage Recommendations

**For most users:**
- Run `install_tools.sh` for a complete dotfiles setup
- This installs all necessary tools and stows your configurations

**For advanced users:**
- Use `setup.sh` to selectively install optional components
- Currently includes Go tools, with more scripts coming in the future
- Perfect for customizing your installation

## Notes

- All configurations are symlinked to maintain a single source of truth
- The `.stow-local-ignore` file prevents documentation from being symlinked
- Backup your existing configurations before installation
- Scripts automatically set proper permissions
- Go tools can be installed optionally via the setup script

## Documentation

Additional documentation and reference files are available in the `docs/` directory:
- VS Code extension list
- Configuration guides
- Setup instructions

## Contributing

Feel free to fork this repository and customize it for your own use. If you have improvements or suggestions, pull requests are welcome!

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Acknowledgments

- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink farm manager
- [Starship](https://starship.rs/) - Cross-shell prompt
- The open-source community for inspiration and tools

---

**Made with ❤️ for a better development environment**
