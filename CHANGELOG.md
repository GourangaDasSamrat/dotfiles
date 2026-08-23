## [0.181.0] - 2026-08-23

### 🚀 Features

- *(scripts)* Promote httpie, integrate biome, and fix package typos (Gouranga Das Samrat)

### 📚 Documentation

- *(changelog)* Update CHANGELOG.md for v0.180.0 [skip ci] (github-actions[bot])
## [0.180.0] - 2026-08-23

### 🚀 Features

- *(termux)* Add pkg manager support (Gouranga Das Samrat)

### 📚 Documentation

- *(changelog)* Update CHANGELOG.md for v0.179.0 [skip ci] (github-actions[bot])

### ⚙️ Miscellaneous Tasks

- Remove unused roumon tool (Gouranga Das Samrat)
## [0.179.0] - 2026-08-22

### 🚀 Features

- *(git)* Add `gone` alias to prune deleted remote branches (Gouranga Das Samrat)

### 💼 Other

- Add justfile for task automation (Gouranga Das Samrat)

### 📚 Documentation

- *(changelog)* Update CHANGELOG.md for v0.178.0 [skip ci] (github-actions[bot])
- Update application launcher shortcut (Gouranga Das Samrat)
- *(termux)* Update package installation order (Gouranga Das Samrat)
- *(termux)* Add jetbrains mono font installation (Gouranga Das Samrat)
- *(vscode)* Use $HOME for extension paths (Gouranga Das Samrat)

### 🎨 Styling

- *(vscode)* Remove trailing comma from settings.json (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(vscode)* Adjust integrated terminal font size (Gouranga Das Samrat)
- *(vscode)* Remove unused eslint run on save settings (Gouranga Das Samrat)
## [0.178.0] - 2026-08-17

### 🚀 Features

- *(scripts)* Add notion to software list (Gouranga Das Samrat)

### 🚜 Refactor

- *(scripts)* Improve APT package detection in softwares.sh (Gouranga Das Samrat)
- *(scripts)* Extract software tool arrays into utility file (Gouranga Das Samrat)

### 📚 Documentation

- *(changelog)* Update CHANGELOG.md for v0.177.0 [skip ci] (github-actions[bot])
- Update README to specify Go requirement for tools (Gouranga Das Samrat)
## [0.177.0] - 2026-08-13

### 🚀 Features

- *(scripts)* Add ARCH_TOOLS support and expand MACOS_TOOLS (Gouranga Das Samrat)

### 🚜 Refactor

- *(vscode,zsh)* Remove redundant root vscode symlinks and cleanup aliases (Gouranga Das Samrat)

### 📚 Documentation

- Add changelog (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(release)* Include non-conventional commits in filter_unconventional (Gouranga Das Samrat)
- *(release)* Auto-commit full CHANGELOG.md on release (Gouranga Das Samrat)
## [0.176.0] - 2026-08-13

### 🚀 Features

- *(deps)* Add git-cliff package to macos and rust toolsets (Gouranga Das Samrat)

### 🎨 Styling

- *(formatter)* Change indentation style from tabs to 2 spaces (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Add vscode user config symlinks (Gouranga Das Samrat)
- Add build type to release notes (Gouranga Das Samrat)
- *(release)* Replace custom bash changelog script with git-cliff (Gouranga Das Samrat)
## [0.175.0] - 2026-08-13

### 🚀 Features

- *(git)* Add codex git commit alias (Gouranga Das Samrat)

### 💼 Other

- Refactor/Delete tmux section from README (#10)

Removed tmux section from README cause tmux has long been removed from this repo. (Priority Zero)
- Chore/biome migration (#11)

* refactor(vscode): migrate to biome formatter

- Replaced prettier with biome as default formatter
- Updated code actions on save for biome
- Removed prettier-vscode and eslint extensions affinities
- Added biome to json schema trusted domains
- Adjusted formatting for long arrays with biome-ignore

* build: add biome configuration file

- Configure formatter with tab indent
- Enable linter with recommended rules
- Set double quotes for javascript
- Enable organize imports action

* docs: update formatter to biome

- Replaced prettier and eslint with biome
- Updated manual install instructions
- Updated vscode extension recommendations

* refactor(helix): replace ESLint and Prettier with Biome for JS/TS/CSS/JSON

- Replace ESLint LSP with Biome LSP proxy for linting and code actions
- Use Biome CLI formatter instead of Prettier for JS, TS, JSX, TSX, CSS, and JSON
- Remove `vscode-eslint-language-server` configuration
- Retain Prettier for unsupported file types (HTML, YAML, Markdown)

* docs(helix): update JS/TS linter and formatter installation to Biome

- Replace eslint and prettier with biome in global installation command

---------

Co-authored-by: Codex <noreply@openai.com> (Gouranga Das Samrat)

### 🚜 Refactor

- *(scripts)* Clarify OS and package manager array names (Gouranga Das Samrat)
## [0.174.1] - 2026-08-11

### 💼 Other

- Fix/build-essential-not-found-on-arch (#9)

* fix(scripts): support base-devel fallback for pacman

- build-essential package doesn't exist on Arch Linux (pacman)
- Arch's equivalent is the base-devel package group
- changed GENERIC_LINUX_TOOLS entry to "build-essential|base-devel"
- reuses existing pipe (pkg1|pkg2) OR-logic in _is_installed/_install_tool
- pacman now falls back to installing base-devel when build-essential is not found in repo

* fix(scripts): support Arch Linux package group detection and base-devel fallback

- Updated _is_installed() pacman logic with 'pacman -Qg' to correctly check group installations

---------

Co-authored-by: Gouranga Das Samrat <gouranga.das.khulna@gmail.com> (Sompa Rani Das)

### 🚜 Refactor

- *(scripts)* Move openssl to common tools array (Gouranga Das Samrat)

### 📚 Documentation

- Update native desktop setup guide (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Chore/fix-github-templates (#7)

* docs: migrate issue and pull request templates

- Converted markdown templates to YAML forms
- Updated issue templates for bug, config, feature
- Moved pull request template to new directory
- Enhances maintainability of forms

* docs(templates): clarify output section guidelines

Replace generic placeholder prompt with an explicit request for screenshots,
terminal logs, and a note to redact sensitive credentials.

Co-authored-by: Copilot Autofix powered by AI <175728472+Copilot@users.noreply.github.com>

---------

Co-authored-by: Codex <noreply@openai.com>
Co-authored-by: Copilot Autofix powered by AI <175728472+Copilot@users.noreply.github.com> (Gouranga Das Samrat)
## [0.174.0] - 2026-08-11

### 🚀 Features

- *(vscode)* Auto approve chat tool urls (Gouranga Das Samrat)
## [0.173.0] - 2026-08-11

### 💼 Other

- Feature/add fedora support (#6)

* feat(scripts): add dnf package manager detection

* feat(scripts): add Fedora and DNF package manager support

- split Linux tool lists into shared, generic, and Fedora-specific toolsets
- add DNF check, install, and group install logic in `_is_installed` and `_install_tool`
- handle DNF system update command in `install_packages`

* Potential fix for pull request finding

Co-authored-by: Copilot Autofix powered by AI <175728472+Copilot@users.noreply.github.com>

---------

Co-authored-by: Copilot Autofix powered by AI <175728472+Copilot@users.noreply.github.com> (Gouranga Das Samrat)

### 🚜 Refactor

- *(dotfiles)* Improve vscode stow logic (Gouranga Das Samrat)

### 📚 Documentation

- Remove 'uSql' from tools list (Gouranga Das Samrat)
## [0.172.0] - 2026-08-06

### 🚀 Features

- *(vscode)* Restructure configuration profiles for cross-platform support (Gouranga Das Samrat)

### 📚 Documentation

- Replace firefox with zen browser (Gouranga Das Samrat)
## [0.171.2] - 2026-07-30

### 🐛 Bug Fixes

- *(zsh)* Update start script path (Gouranga Das Samrat)

### 📚 Documentation

- Update install commands and fix pipes (Gouranga Das Samrat)
## [0.171.1] - 2026-07-28

### 🐛 Bug Fixes

- *(fonts)* Move fonts to standard dir (Gouranga Das Samrat)
## [0.171.0] - 2026-07-28

### 🚀 Features

- *(claude)* Add custom status line (Gouranga Das Samrat)
## [0.170.0] - 2026-07-27

### 🚀 Features

- *(bash)* Update PATH with new bin directories (Gouranga Das Samrat)
## [0.169.0] - 2026-07-27

### 🚀 Features

- *(claude)* Add custom dracula theme (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Centralize status printing in utils (Gouranga Das Samrat)

### 📚 Documentation

- *(termux)* Add Claude Code CLI installation guide and VSCode config (Gouranga Das Samrat)
## [0.168.0] - 2026-07-25

### 🚀 Features

- *(softwares)* Add cloudflared and remove slim (Gouranga Das Samrat)

### 🚜 Refactor

- *(gh)* Externalize aliases to scripts (Gouranga Das Samrat)

### 📚 Documentation

- *(termux)* Add engrampa to package list (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Configure gitattributes to detect graphql (Gouranga Das Samrat)
- *(vscode)* Update settings (Gouranga Das Samrat)
- Remove archived dotfiles and zsh functions (Gouranga Das Samrat)
## [0.167.0] - 2026-07-23

### 🚀 Features

- *(gh)* Add cli scripts for github stats (Gouranga Das Samrat)
## [0.166.0] - 2026-07-23

### 🚀 Features

- *(gh)* Add graphql filters for user stats (Gouranga Das Samrat)
## [0.165.0] - 2026-07-23

### 🚀 Features

- *(gh)* Add graphql queries for user stats (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Chore(vscode): refine user settings and keybindings
- disable native terminal keybindings
- disable copilot chat tips (Gouranga Das Samrat)
## [0.164.0] - 2026-07-22

### 🚀 Features

- *(kitty)* Enhance config with layouts and shortcuts (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Optimize syntax, cleanup quotes, and remove unused aws plugin (Gouranga Das Samrat)
- *(docs,scripts)* Standardize tool installation guides and update dotfiles bootstrap (Gouranga Das Samrat)
## [0.163.0] - 2026-07-19

### 🚀 Features

- *(mongosh)* Add custom dracula-themed mongoshrc configuration (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Simplify Termux moto_server env configuration (Gouranga Das Samrat)
- *(zsh)* Remove moto_server setup and add mongosh alias (Gouranga Das Samrat)
- *(aws)* Make switcher conditional and remove awscli from macos tools (Gouranga Das Samrat)
## [0.162.0] - 2026-07-17

### 🚀 Features

- *(zsh)* Add moto_server replay alias and generalize apt wrapper (Gouranga Das Samrat)
## [0.161.0] - 2026-07-17

### 🚀 Features

- *(scripts)* Add awscli to macOS tools list (Gouranga Das Samrat)
## [0.160.0] - 2026-07-17

### 🚀 Features

- *(zsh)* Add AWS environment switcher and enable AWS plugin (Gouranga Das Samrat)
## [0.159.0] - 2026-07-17

### 🚀 Features

- *(zsh)* Add moto_server environment variables and optimize bun check (Gouranga Das Samrat)
## [0.158.1] - 2026-07-17

### 🐛 Bug Fixes

- *(zsh)* Correct eza alias and termux paths (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(scripts)* Source fonts installation script (Gouranga Das Samrat)
## [0.158.0] - 2026-07-17

### 🚀 Features

- *(bash)* Enable bash completion from $PREFIX dir (Gouranga Das Samrat)

### 📚 Documentation

- Add fonts script to readme (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(vscode)* Optimize settings and update code lens font (Gouranga Das Samrat)
## [0.157.0] - 2026-07-16

### 🚀 Features

- *(scripts)* Add dependency checks and installation logs to fonts script (Gouranga Das Samrat)
## [0.156.0] - 2026-07-16

### 🚀 Features

- *(scripts)* Add sourceable Apple SF-Pro and SF-Mono fonts installer for Linux (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Optimize path management and dynamic homebrew loading (Gouranga Das Samrat)

### 📚 Documentation

- Remove zsh documentation and related feature references (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Chore(vscode): adjust vs code font settings
- add sf mono to terminal fonts
- remove monolisa from markdown preview (Gouranga Das Samrat)
## [0.155.1] - 2026-07-12

### 🐛 Bug Fixes

- *(deps)* Ensure correct openssl packages by os (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Rewrite mkdir and rm overrides (Gouranga Das Samrat)
- *(zsh)* Enhance archive functions (Gouranga Das Samrat)
- *(zsh)* Remove unused utility functions (Gouranga Das Samrat)
- *(zsh)* Improve zsh functions and port validation (Gouranga Das Samrat)
- *(zsh)* Improve network functions with zsh natives (Gouranga Das Samrat)

### 📚 Documentation

- Docs(vscode): delete vscode settings guide`
- Removed comprehensive settings guide
- Streamlined overall documentation
- Guide was outdated and no longer needed (Gouranga Das Samrat)
- *(zsh)* Remove python dev profile references (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(vscode)* Update editor configuration (Gouranga Das Samrat)
- *(vscode)* Tighten rust-analyzer clippy lint config (Gouranga Das Samrat)
- *(zsh)* Adjust shell configuration (Gouranga Das Samrat)
- *(vscode)* Adjust dev environment settings (Gouranga Das Samrat)
## [0.155.0] - 2026-07-09

### 🚀 Features

- *(scripts)* Add redis to macOS software installation list (Gouranga Das Samrat)

### 🚜 Refactor

- *(aliases)* Convert apt alias to a custom shell function (Gouranga Das Samrat)
## [0.154.0] - 2026-07-06

### 🚀 Features

- *(zsh)* Add conditional bun function and clean start alias (Gouranga Das Samrat)
## [0.153.0] - 2026-07-03

### 🚀 Features

- *(scripts)* Add JetBrains Mono Nerd Font to macOS software list (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(vscode)* Update browser settings (Gouranga Das Samrat)
## [0.152.0] - 2026-07-03

### 🚀 Features

- *(ytm-player)* Add named theme selection (Gouranga Das Samrat)

### 🚜 Refactor

- Refactor(scripts): move kitty and httpie to macOS tools
- Mark tools as platform-specific
- Ensure correct installation per OS (Gouranga Das Samrat)
- *(scripts)* Reformat dotfiles setup script (Gouranga Das Samrat)
- *(go-tools)* Optimize Go binaries and lint setup (Gouranga Das Samrat)
- *(termux)* Use $PREFIX for Termux paths (Gouranga Das Samrat)

### 📚 Documentation

- *(native-desktop)* Enhance desktop customization guide (Gouranga Das Samrat)
- Make native desktop script executable (Gouranga Das Samrat)
- Remove tmux from tools list (Gouranga Das Samrat)
- *(termux)* Use $PREFIX for paths (Gouranga Das Samrat)
- Update README for removed commands (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(archive)* Remove obsolete alacritty, neovim, tmux, and zsh configurations (Gouranga Das Samrat)
- *(vscode)* Disable clippy::cargo lint warnings (Gouranga Das Samrat)
- *(vscode)* Disable clippy::cargo lint warnings (Gouranga Das Samrat)

### ◀️ Revert

- Roll back to tag v2.14.0 (Gouranga Das Samrat)
## [0.151.0] - 2026-06-22

### 🚀 Features

- *(zsh)* Configure local timezone for android shell environment (Gouranga Das Samrat)
## [0.150.0] - 2026-06-19

### 🚀 Features

- *(scripts)* Update macos software list and rearrange tools (Gouranga Das Samrat)
## [0.149.0] - 2026-06-15

### 🚀 Features

- *(kitty)* Add terminal emulator config (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(vscode)* Migrate external macOS terminal emulator from Alacritty to Kitty (Gouranga Das Samrat)
## [0.148.0] - 2026-06-15

### 🚀 Features

- *(zsh)* Add smart apt shortcut and rename debian home alias (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Drop nvm for fnm environment configuration (Gouranga Das Samrat)

### 📚 Documentation

- *(readme)* Swap alacritty for kitty in core stack description (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(scripts)* Update macos software packages (Gouranga Das Samrat)
## [0.147.0] - 2026-06-15

### 🚀 Features

- *(scripts)* Update software installation list (Gouranga Das Samrat)

### 📚 Documentation

- *(zsh)* Document bind-all flag (Gouranga Das Samrat)
- *(zsh)* Mark apireq and ask functions as archived (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(git)* Optimize and modernize git configuration (Gouranga Das Samrat)
- *(alacritty)* Archive configuration files (Gouranga Das Samrat)
## [0.146.0] - 2026-06-13

### 🚀 Features

- *(zsh)* Add bind-all option to serve (Gouranga Das Samrat)
## [0.145.0] - 2026-06-13

### 🚀 Features

- *(wallpaper)* Add spooky-season wallpaper URL (Gouranga Das Samrat)

### 📚 Documentation

- *(README)* Remove unused things (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(cspell)* Add ciphertext and keysize to tech-tools dictionary (Gouranga Das Samrat)
## [0.144.0] - 2026-06-09

### 🚀 Features

- *(scripts)* Add new packages to software and macOS lists (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Move ai and apireq functions to archive (Gouranga Das Samrat)

### 📚 Documentation

- Update tools and script architecture (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(zsh)* Update plugins list and clean up modules (Gouranga Das Samrat)
## [0.143.1] - 2026-06-09

### 🐛 Bug Fixes

- *(scripts)* Rename packages script to softwares (Gouranga Das Samrat)
## [0.143.0] - 2026-06-09

### 🚀 Features

- *(scripts)* Add ripgrep and tableplus (Gouranga Das Samrat)

### 🚜 Refactor

- *(packages)* Move alacritty to Linux tools (Gouranga Das Samrat)
- *(scripts)* Reorganize script structure, sync mac tools, and disable TPM (Gouranga Das Samrat)
- *(scripts)* Migrate shfmt to common tools array (Gouranga Das Samrat)
- *(scripts)* Update system and language tool arrays (Gouranga Das Samrat)
- *(scripts)* Reorganize software package lists by category (Gouranga Das Samrat)

### 📚 Documentation

- Update application lists (Gouranga Das Samrat)
## [0.142.0] - 2026-06-07

### 🚀 Features

- *(scripts)* Update installed macOS GUI apps (Gouranga Das Samrat)

### 📚 Documentation

- *(zsh)* Document `shd` utility function (Gouranga Das Samrat)
## [0.141.0] - 2026-06-05

### 🚀 Features

- *(zsh)* Add function to scan heavy deps (Gouranga Das Samrat)

### 📚 Documentation

- Update README with macOS GUI setup (Gouranga Das Samrat)
## [0.140.0] - 2026-06-05

### 🚀 Features

- *(scripts)* Add macOS GUI app installer script (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(vscode)* Remove trailing space from keybindings (Gouranga Das Samrat)
- Chore(vscode): add TOML formatter and schema settings
- Enable EvenBetterToml formatter
- Configure TOML schema associations
- Auto-align entries and reorder keys (Gouranga Das Samrat)
## [0.139.0] - 2026-06-01

### 🚀 Features

- *(zsh)* Add 'open' alias for Linux (Gouranga Das Samrat)
## [0.138.0] - 2026-06-01

### 🚀 Features

- *(vscode)* Add Godot development support (Gouranga Das Samrat)
## [0.137.0] - 2026-05-31

### 🚀 Features

- *(zsh)* Add 'ask' to blocked prefixes and fix gemini typo (Gouranga Das Samrat)

### 📚 Documentation

- *(zsh)* Add ask command for AI queries (Gouranga Das Samrat)
## [0.136.0] - 2026-05-31

### 🚀 Features

- *(zsh)* Add AI question answering function (Gouranga Das Samrat)

### 🚜 Refactor

- *(rust)* Relax clippy indexing_slicing warning (Gouranga Das Samrat)

### 📚 Documentation

- Update VS Code settings and tools list (Gouranga Das Samrat)

### 🎨 Styling

- *(vscode)* Format fontLigatures array on single line (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(git)* Improve commit message hook formatting (Gouranga Das Samrat)
- *(git)* Improve commit-msg hook sed command (Gouranga Das Samrat)
- *(git)* Configure Git LFS settings (Gouranga Das Samrat)
- Enhance clippy linting rules and zsh history ignore (Gouranga Das Samrat)
## [0.135.0] - 2026-05-29

### 🚀 Features

- Update Cspell and VSCode settings docs (Gouranga Das Samrat)
## [0.134.0] - 2026-05-29

### 🚀 Features

- *(rust-analyzer)* Update clippy lints (Gouranga Das Samrat)

### 🚜 Refactor

- *(aliases)* Update af and remove gh aliases (Gouranga Das Samrat)

### 📚 Documentation

- Add TOML formatter to VS Code settings (Gouranga Das Samrat)
- Exclude target dir and Cargo.lock (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Move neovim and tmux to archive (Gouranga Das Samrat)
- Update system packages and zsh aliases (Gouranga Das Samrat)
- *(vscode)* Exclude build artifacts from search (Gouranga Das Samrat)
## [0.133.0] - 2026-05-23

### 🚀 Features

- *(gpg)* Configure pinentry program (Gouranga Das Samrat)
## [0.132.0] - 2026-05-23

### 🚀 Features

- *(vscode)* Configure Alacritty for macOS terminal (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(git)* Configure git to use ssh for github (Gouranga Das Samrat)
## [0.131.2] - 2026-05-22

### 🐛 Bug Fixes

- *(zsh)* Correct df alias path (Gouranga Das Samrat)

### 🚜 Refactor

- *(rm)* Add protected paths and improved trash detection (Gouranga Das Samrat)
## [0.131.1] - 2026-05-21

### 🐛 Bug Fixes

- *(rm)* Validate targets before deletion (Gouranga Das Samrat)

### 🚜 Refactor

- *(history)* Block sensitive git push commands (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update package lists for Linux and macOS (Gouranga Das Samrat)
## [0.131.0] - 2026-05-20

### 🚀 Features

- *(zsh)* Add ! alias for rm to use trash (Gouranga Das Samrat)
## [0.130.0] - 2026-05-20

### 🚀 Features

- *(zsh)* Add gtrash completion (Gouranga Das Samrat)
## [0.129.0] - 2026-05-20

### 🚀 Features

- *(bash)* Add safe delete alias (Gouranga Das Samrat)
## [0.128.0] - 2026-05-20

### 🚀 Features

- *(rm)* Add trash support for rm (Gouranga Das Samrat)
## [0.127.0] - 2026-05-20

### 🚀 Features

- *(go-tools)* Add gtrash installation logic (Gouranga Das Samrat)
## [0.126.0] - 2026-05-20

### 🚀 Features

- *(dotfiles)* Add OS-specific stow logic (Gouranga Das Samrat)

### 🚜 Refactor

- *(env)* Improve zsh environment configuration (Gouranga Das Samrat)
## [0.125.0] - 2026-05-19

### 🚀 Features

- *(git)* Configure delta pager and add to packages (Gouranga Das Samrat)
## [0.124.0] - 2026-05-19

### 🚀 Features

- *(cargo)* Add cargo-modules tool (Gouranga Das Samrat)

### 📚 Documentation

- Add VS Code custom keybindings (Gouranga Das Samrat)
- Add VS Code settings documentation (Gouranga Das Samrat)
- Add core zsh modules documentation (Gouranga Das Samrat)
- Add zsh plugins documentation (Gouranga Das Samrat)
- Add zsh customization guide (Gouranga Das Samrat)
- Add Zsh functions documentation (Gouranga Das Samrat)
- Add Zsh architecture documentation (Gouranga Das Samrat)
- Add zsh configuration README (Gouranga Das Samrat)
- Improve table formatting in zsh docs (Gouranga Das Samrat)
- Improve documentation structure (Gouranga Das Samrat)
- *(termux)* Update debian symlink path (Gouranga Das Samrat)
## [0.123.0] - 2026-05-16

### 🚀 Features

- *(vscode)* Add keybindings for new window (Gouranga Das Samrat)
## [0.122.0] - 2026-05-16

### 🚀 Features

- *(aliases)* Add afk and play aliases (Gouranga Das Samrat)
## [0.121.0] - 2026-05-16

### 🚀 Features

- *(go-tools)* Add roumon to go tools (Gouranga Das Samrat)

### 📚 Documentation

- Add bun installation instructions for Termux (Gouranga Das Samrat)
## [0.120.0] - 2026-05-13

### 🚀 Features

- *(env)* Add BUN_OPTIONS for Termux (Gouranga Das Samrat)
## [0.119.0] - 2026-05-11

### 🚀 Features

- *(tmux)* Enhance weather display and config (Gouranga Das Samrat)

### 🚜 Refactor

- Reorganize SDK tools into dedicated folder (Gouranga Das Samrat)

### 📚 Documentation

- Add language servers installation guide (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update git editor to helix (Gouranga Das Samrat)
- Organize go tools script (Gouranga Das Samrat)
## [0.118.0] - 2026-05-10

### 🚀 Features

- *(sql)* Add SQL language support (Gouranga Das Samrat)

### 🚜 Refactor

- *(scripts)* Improve wallpaper script error handling (Gouranga Das Samrat)
- Remove neovim from package list (Gouranga Das Samrat)

### 📚 Documentation

- *(termux)* Add script for termux native desktop (Gouranga Das Samrat)
- *(termux)* Update native-desktop installation (Gouranga Das Samrat)
- Add CodeLLDB to VS Code extensions (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(git-hooks)* Improve pre-push script (Gouranga Das Samrat)
## [0.117.1] - 2026-05-08

### 🐛 Bug Fixes

- *(dotfiles)* Fix git-hooks path (Gouranga Das Samrat)

### 📚 Documentation

- Add sheets and eget to go tools (Gouranga Das Samrat)
- Update git send-email guide (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Improve release notes generation (Gouranga Das Samrat)
- Grant actions read permission (Gouranga Das Samrat)
## [0.117.0] - 2026-05-08

### 🚀 Features

- *(scripts)* Add eget and sheets to go_tools (Gouranga Das Samrat)

### 💼 Other

- Add release workflow (Gouranga Das Samrat)
## [0.116.1] - 2026-05-07

### 🐛 Bug Fixes

- *(env)* Correctly quote local bin path (Gouranga Das Samrat)

### 🚜 Refactor

- Rename documentation files to use consistent kebab-case (Gouranga Das Samrat)

### 📚 Documentation

- Update README with new tools (Gouranga Das Samrat)
- Refine git send-email setup guide (Gouranga Das Samrat)
- Add Termux native desktop setup guide (Gouranga Das Samrat)
- Add PRoot Debian setup guide (Gouranga Das Samrat)
## [0.116.0] - 2026-05-03

### 🚀 Features

- *(env)* Add Go and Cargo env vars (Gouranga Das Samrat)
## [0.115.0] - 2026-05-03

### 🚀 Features

- *(aliases)* Add cargo aliases (Gouranga Das Samrat)

### 📚 Documentation

- Add cargo tools to README (Gouranga Das Samrat)
- Update template paths in documentation (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Remove commented out Helix language config (Gouranga Das Samrat)
- Add new tools to scripts (Gouranga Das Samrat)
## [0.114.0] - 2026-05-01

### 🚀 Features

- *(scripts)* Add cargo_tools.sh script (Gouranga Das Samrat)
## [0.113.0] - 2026-05-01

### 🚀 Features

- *(network)* Improve myip function with jq fallback (Gouranga Das Samrat)
## [0.112.0] - 2026-05-01

### 🚀 Features

- *(keybindings)* Add Mac equivalents for VSCode shortcuts (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update gitconfig formatting (Gouranga Das Samrat)
## [0.111.0] - 2026-04-30

### 🚀 Features

- *(packages)* Add helix to common tools (Gouranga Das Samrat)
## [0.110.1] - 2026-04-30

### 🐛 Bug Fixes

- *(helix)* Change line-number to absolute (Gouranga Das Samrat)
## [0.110.0] - 2026-04-30

### 🚀 Features

- *(helix)* Configure language servers and formatters (Gouranga Das Samrat)
## [0.109.0] - 2026-04-30

### 🚀 Features

- *(config)* Add Helix editor configuration (Gouranga Das Samrat)

### 📚 Documentation

- Update GitHub issue templates and PR template (Gouranga Das Samrat)
- Add guide for git send-email in termux (Gouranga Das Samrat)
## [0.108.0] - 2026-04-30

### 🚀 Features

- *(vscode)* Add Rust competitive programming snippets (Gouranga Das Samrat)
## [0.107.0] - 2026-04-30

### 🚀 Features

- *(git)* Configure git for send email (Gouranga Das Samrat)

### 📚 Documentation

- Update git alias and zshenv (Gouranga Das Samrat)
## [0.106.0] - 2026-04-29

### 🚀 Features

- *(git)* Add 'unstage' alias (Gouranga Das Samrat)

### 🚜 Refactor

- *(scripts)* Improve python tools installer logic (Gouranga Das Samrat)
- *(scripts)* Improve go tools installation script (Gouranga Das Samrat)
## [0.105.0] - 2026-04-28

### 🚀 Features

- *(env)* Configure Rust/Cargo for zsh (Gouranga Das Samrat)

### 📚 Documentation

- Add rust dev profile to vscode extensions (Gouranga Das Samrat)
## [0.104.0] - 2026-04-27

### 🚀 Features

- *(aliases)* Add rust dev vscode alias (Gouranga Das Samrat)

### 🚜 Refactor

- *(docs)* Reorganize docs into setup, vscode, and templates directories (Gouranga Das Samrat)

### 📚 Documentation

- Add 'expose' command and update go tools (Gouranga Das Samrat)
- Add Termux installation instructions (Gouranga Das Samrat)
- Add vscode termux setup guide (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update word lists and wallpaper URLs (Gouranga Das Samrat)
- Update VS Code settings (Gouranga Das Samrat)
## [0.103.0] - 2026-04-26

### 🚀 Features

- *(zsh)* Add 'expose' function and improve 't' (Gouranga Das Samrat)
## [0.102.0] - 2026-04-26

### 🚀 Features

- *(deps)* Add slim to go tools (Gouranga Das Samrat)

### 🎨 Styling

- Apply consistent trailing commas to settings (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(zsh)* Add Termux start and Python code profile aliases (Gouranga Das Samrat)
- *(cspell)* Add Eulerian and Qubit to wordlist (Gouranga Das Samrat)
## [0.101.0] - 2026-04-20

### 🚀 Features

- Configure issue templates (Gouranga Das Samrat)

### 🚜 Refactor

- *(env)* Improve zsh environment setup (Gouranga Das Samrat)

### 📚 Documentation

- Update tech tools list (Gouranga Das Samrat)
- Add manual installation guide (Gouranga Das Samrat)
- Add pull request template (Gouranga Das Samrat)
- Add issue templates (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update golangci-lint version and VS Code snippets (Gouranga Das Samrat)
- Update VS Code settings (Gouranga Das Samrat)
- Disable auto updates for extensions and tests (Gouranga Das Samrat)
- Add shell script validation workflow (Gouranga Das Samrat)
- Add script validation workflow (#5) (Gouranga Das Samrat)
## [0.100.0] - 2026-04-18

### 🚀 Features

- *(scripts)* Add gotests and govulncheck to go_tools (Gouranga Das Samrat)

### 📚 Documentation

- Update README with new tools and formatting (Gouranga Das Samrat)
## [0.99.0] - 2026-04-15

### 🚀 Features

- *(utils)* Add timestamped logger function (Gouranga Das Samrat)
## [0.98.0] - 2026-04-14

### 🚀 Features

- *(zsh)* Display session start time (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(vscode)* Refactor spell checker and Copilot settings (Gouranga Das Samrat)
## [0.97.0] - 2026-04-13

### 🚀 Features

- *(cspell)* Add personal-names and tech-tools dictionaries (Gouranga Das Samrat)
## [0.96.0] - 2026-04-13

### 🚀 Features

- *(env)* Add PNPM to environment variables (Gouranga Das Samrat)
## [0.95.0] - 2026-04-11

### 🚀 Features

- *(copilot)* Configure commit message generation (Gouranga Das Samrat)
## [0.94.0] - 2026-04-11

### 🚀 Features

- *(network)* Add myip command (Gouranga Das Samrat)
## [0.93.0] - 2026-04-10

### 🚀 Features

- *(vscode)* Add font zoom keybindings and Copilot commit instructions (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Remove redundant help messages from utils.zsh (Gouranga Das Samrat)

### 📚 Documentation

- Add new CLI tools to README (Gouranga Das Samrat)
## [0.92.0] - 2026-04-09

### 🚀 Features

- *(zsh)* Add network module to zshrc (Gouranga Das Samrat)
## [0.91.0] - 2026-04-09

### 🚀 Features

- *(zsh)* Add network status and inspect functions (Gouranga Das Samrat)
## [0.90.0] - 2026-04-09

### 🚀 Features

- *(utils)* Add weather check function (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Remove unused git alias and zsh unset (Gouranga Das Samrat)
- Improve script and shell configurations (Gouranga Das Samrat)
## [0.89.0] - 2026-04-08

### 🚀 Features

- *(packages)* Add git-lfs to common tools (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Unset gp alias and function (Gouranga Das Samrat)
## [0.88.0] - 2026-04-08

### 🚀 Features

- *(git)* Add custom push alias and pre-push hook (Gouranga Das Samrat)
## [0.87.0] - 2026-04-08

### 🚀 Features

- *(env)* Configure environment variables and paths (Gouranga Das Samrat)

### 🚜 Refactor

- Simplify security wrapper for package managers (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Fix trailing commas and formatting in settings (Gouranga Das Samrat)
## [0.86.0] - 2026-04-06

### 🚀 Features

- *(lua)* Add lua development profile (Gouranga Das Samrat)

### 📚 Documentation

- Update README and VS Code extensions docs (Gouranga Das Samrat)
## [0.85.0] - 2026-04-05

### 🚀 Features

- *(zsh)* Add whois command to zsh config (Gouranga Das Samrat)
## [0.84.0] - 2026-04-05

### 🚀 Features

- *(zsh)* Add whois lookup function (Gouranga Das Samrat)
## [0.83.0] - 2026-04-05

### 🚀 Features

- *(vscode)* Update keybindings and spell check words (Gouranga Das Samrat)

### 🚜 Refactor

- *(security)* Improve package script handling (Gouranga Das Samrat)

### 📚 Documentation

- Update VS Code extensions list (Gouranga Das Samrat)
## [0.82.0] - 2026-04-05

### 🚀 Features

- *(zsh)* Add security wrappers for package managers (Gouranga Das Samrat)
## [0.81.0] - 2026-04-05

### 🚀 Features

- *(zsh)* Add security functions (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Improve PATH management (Gouranga Das Samrat)
- *(zsh)* Improve VS Code alias logic (Gouranga Das Samrat)

### 📚 Documentation

- Update secrets loader template (Gouranga Das Samrat)
## [0.80.0] - 2026-04-02

### 🚀 Features

- *(env)* Add uv to PATH (Gouranga Das Samrat)
## [0.79.0] - 2026-04-02

### 🚀 Features

- *(vscode)* Update VS Code settings (Gouranga Das Samrat)
## [0.78.1] - 2026-04-02

### 🐛 Bug Fixes

- *(history)* Block sensitive env commands (Gouranga Das Samrat)
## [0.78.0] - 2026-04-02

### 🚀 Features

- *(vscode)* Update editor and chat font settings (Gouranga Das Samrat)

### 🚜 Refactor

- *(scripts)* Rename wallpaper URL file (Gouranga Das Samrat)
## [0.77.1] - 2026-04-01

### 🐛 Bug Fixes

- Rename pluggins folder to plugins (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Move ZDOTDIR to .zshenv (Gouranga Das Samrat)
## [0.77.0] - 2026-04-01

### 🚀 Features

- *(dotfiles)* Add ytm-player to stow and new bashrc (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Improve history and reload alias (Gouranga Das Samrat)
## [0.76.0] - 2026-04-01

### 🚀 Features

- *(wallpapers)* Download wallpapers from URLs (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Streamline .zshrc configuration (Gouranga Das Samrat)
- *(zsh)* Migrate flat config to modular subdirectory structure (Gouranga Das Samrat)
- *(zsh)* Update module loader for new directory structure (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(zsh)* Move zsh configuration (Gouranga Das Samrat)
## [0.75.0] - 2026-03-31

### 🚀 Features

- *(zsh)* Add environment configuration (Gouranga Das Samrat)
## [0.74.0] - 2026-03-31

### 🚀 Features

- *(zsh)* Configure sensitive history filtering (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Streamline shell scripts and improve prompts (Gouranga Das Samrat)

### 📚 Documentation

- Add Todo Tree extension to list (Gouranga Das Samrat)
## [0.73.0] - 2026-03-30

### 🚀 Features

- *(vscode)* Configure python formatter and TODO tree (Gouranga Das Samrat)

### 📚 Documentation

- Update README and VS Code settings (Gouranga Das Samrat)
## [0.72.0] - 2026-03-29

### 🚀 Features

- *(packages)* Add 'uv' to macOS tools (Gouranga Das Samrat)
## [0.71.0] - 2026-03-29

### 🚀 Features

- *(scripts)* Use uv for Python tool installation (Gouranga Das Samrat)
## [0.70.0] - 2026-03-29

### 🚀 Features

- Enhance go tools installation script (Gouranga Das Samrat)

### 📚 Documentation

- Update README and VS Code extensions list (Gouranga Das Samrat)
## [0.69.1] - 2026-03-29

### 🐛 Bug Fixes

- *(zsh)* Enhance history security (Gouranga Das Samrat)
## [0.69.0] - 2026-03-29

### 🚀 Features

- *(scripts)* Add python tools installer (Gouranga Das Samrat)

### 📚 Documentation

- Add env-save, env-load, lock-vault to README (Gouranga Das Samrat)
## [0.68.0] - 2026-03-28

### 🚀 Features

- *(zsh)* Add pass integration for env vars (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update VS Code settings and keybindings (Gouranga Das Samrat)
## [0.67.0] - 2026-03-27

### 🚀 Features

- Add neovim to stow symlinks (Gouranga Das Samrat)
## [0.66.0] - 2026-03-27

### 🚀 Features

- *(nvim)* Add alpha-nvim dashboard (Gouranga Das Samrat)

### 📚 Documentation

- Improve README formatting and readability (Gouranga Das Samrat)
## [0.65.0] - 2026-03-27

### 🚀 Features

- *(zsh)* Add Go bin to PATH and chpwd hook (Gouranga Das Samrat)
## [0.64.0] - 2026-03-27

### 🚀 Features

- *(zsh)* Add chpwd hook for venvs and tools (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update common tools list (Gouranga Das Samrat)
## [0.63.0] - 2026-03-27

### 🚀 Features

- *(scripts)* Add 'air' to go_tools (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Improve gpg-agent lock condition (Gouranga Das Samrat)

### 📚 Documentation

- Update VS Code extensions and settings (Gouranga Das Samrat)
- Add usql and zsh secrets templates (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Add GPG_TTY export to zshrc (Gouranga Das Samrat)
- Update VS Code settings for JS/TS and SQL (Gouranga Das Samrat)
## [0.62.0] - 2026-03-24

### 🚀 Features

- *(git)* Enable GPG signing for commits (Gouranga Das Samrat)

### 📚 Documentation

- Add pre-push hook description (Gouranga Das Samrat)
## [0.61.0] - 2026-03-24

### 🚀 Features

- *(vault)* Auto lock vault every 15 min (Gouranga Das Samrat)
## [0.60.0] - 2026-03-24

### 🚀 Features

- *(zsh)* Add gpg vault lock alias (Gouranga Das Samrat)
## [0.59.0] - 2026-03-24

### 🚀 Features

- *(scripts)* Add pass to common tools (Gouranga Das Samrat)
## [0.58.0] - 2026-03-24

### 🚀 Features

- *(git)* Add pre-push hook for security (Gouranga Das Samrat)

### 📚 Documentation

- Update README with new present commands (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update package list (Gouranga Das Samrat)
## [0.57.0] - 2026-03-23

### 🚀 Features

- *(vscode)* Update default clone directory (Gouranga Das Samrat)
## [0.56.0] - 2026-03-23

### 🚀 Features

- *(aliases)* Organize and add new aliases (Gouranga Das Samrat)
## [0.55.0] - 2026-03-23

### 🚀 Features

- *(gh)* Add comprehensive contribution tracking aliases (Gouranga Das Samrat)
## [0.54.0] - 2026-03-23

### 🚀 Features

- *(ytm)* Add ytm configuration files (Gouranga Das Samrat)

### 📚 Documentation

- Enhance gh cli command descriptions (Gouranga Das Samrat)
## [0.53.0] - 2026-03-23

### 🚀 Features

- *(dotfiles)* Include gh in stow symlinks (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Add mpv to common tools (Gouranga Das Samrat)
## [0.52.0] - 2026-03-23

### 🚀 Features

- *(gh)* Add commit summary aliases (Gouranga Das Samrat)

### 📚 Documentation

- Add github cli aliases to README (Gouranga Das Samrat)
## [0.51.0] - 2026-03-22

### 🚀 Features

- *(config)* Update usql initialization settings (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Add neovim to common tools (Gouranga Das Samrat)
## [0.50.0] - 2026-03-22

### 🚀 Features

- *(gh)* Add gh CLI configuration (Gouranga Das Samrat)

### 📚 Documentation

- Change title from 'Software Engineer' to 'Software Developer' (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Migrate VS Code settings and snippets (Gouranga Das Samrat)
## [0.49.0] - 2026-03-20

### 🚀 Features

- *(zsh)* Load local secrets from .zsh_secrets (Gouranga Das Samrat)
## [0.48.0] - 2026-03-20

### 🚀 Features

- *(alacritty)* Increase font size (Gouranga Das Samrat)

### 📚 Documentation

- Add uSql to programming tools in README (Gouranga Das Samrat)
- Remove unused script descriptions (Gouranga Das Samrat)
- Remove unused script descriptions (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Add default usql configuration (Gouranga Das Samrat)
- Remove unused detect.zsh and ff function (Gouranga Das Samrat)
- Remove unused weather.zsh (Gouranga Das Samrat)
## [0.47.0] - 2026-03-11

### 🚀 Features

- *(dotfiles)* Include usql configuration (Gouranga Das Samrat)
## [0.46.0] - 2026-03-11

### 🚀 Features

- *(zsh)* Add usql alias (Gouranga Das Samrat)

### 📚 Documentation

- Update README with new design and features (Gouranga Das Samrat)
- Update README with new emojis and formatting (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Add usql to common tools (Gouranga Das Samrat)
## [0.45.0] - 2026-03-10

### 🚀 Features

- *(zsh)* Add system cleanup utility (Gouranga Das Samrat)
## [0.44.0] - 2026-03-10

### 🚀 Features

- *(zsh)* Add OS and privilege detection utilities (Gouranga Das Samrat)
## [0.43.0] - 2026-03-09

### 🚀 Features

- *(spellcheck)* Add 'redis' to dictionary (Gouranga Das Samrat)
## [0.42.0] - 2026-03-09

### 🚀 Features

- *(starship)* Add vscode version module (Gouranga Das Samrat)
## [0.41.0] - 2026-03-08

### 🚀 Features

- *(zsh)* Add 'code-d' alias (Gouranga Das Samrat)

### 📚 Documentation

- Update VS Code extensions documentation (Gouranga Das Samrat)
## [0.40.0] - 2026-03-06

### 🚀 Features

- *(vscode)* Configure VS Code settings (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update VS Code keybindings (Gouranga Das Samrat)
## [0.39.0] - 2026-03-06

### 🚀 Features

- *(git)* Add undo alias for reset --soft HEAD~1 (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Remove weather zsh module sourcing (Gouranga Das Samrat)
## [0.38.0] - 2026-03-05

### 🚀 Features

- *(settings)* Configure VS Code editor and extensions (Gouranga Das Samrat)

### 📚 Documentation

- Update VS Code extensions list format (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update VS Code settings (Gouranga Das Samrat)
## [0.37.0] - 2026-03-01

### 🚀 Features

- Enhance apireq.zsh with .http file support (Gouranga Das Samrat)
## [0.36.0] - 2026-02-25

### 🚀 Features

- *(starship)* Add many language and tool integrations (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Update ls alias for eza (Gouranga Das Samrat)
## [0.35.0] - 2026-02-25

### 🚀 Features

- Add gh to common tools (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Remove unused fzf theme functions (Gouranga Das Samrat)
## [0.34.0] - 2026-02-24

### 🚀 Features

- *(fzf)* Integrate fzf-tab plugin (Gouranga Das Samrat)
## [0.33.0] - 2026-02-24

### 🚀 Features

- *(plugins)* Add fzf-tab installation (Gouranga Das Samrat)
## [0.32.0] - 2026-02-24

### 🚀 Features

- *(scripts)* Add shfmt to common tools (Gouranga Das Samrat)
## [0.31.0] - 2026-02-24

### 🚀 Features

- *(git)* Add log aliases for month (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Improve alias definitions (Gouranga Das Samrat)

### 📚 Documentation

- Add fd to dependencies (Gouranga Das Samrat)
## [0.30.0] - 2026-02-23

### 🚀 Features

- *(packages)* Support alternative package names (Gouranga Das Samrat)
## [0.29.0] - 2026-02-23

### 🚀 Features

- *(zsh)* Add fzf configuration (Gouranga Das Samrat)
## [0.28.0] - 2026-02-22

### 🚀 Features

- *(zsh)* Integrate fzf and organize aliases (Gouranga Das Samrat)

### 📚 Documentation

- Update README with new zsh scripts and tools (Gouranga Das Samrat)
## [0.27.0] - 2026-02-22

### 🚀 Features

- *(zsh)* Add api request utility (Gouranga Das Samrat)
## [0.26.0] - 2026-02-22

### 🚀 Features

- *(zsh)* Add interactive API request builder (Gouranga Das Samrat)
## [0.25.0] - 2026-02-22

### 🚀 Features

- *(weather)* Enhance weather command output and help (Gouranga Das Samrat)
## [0.24.0] - 2026-02-22

### 🚀 Features

- *(zsh)* Add help messages and improve prompts (Gouranga Das Samrat)
## [0.23.0] - 2026-02-22

### 🚀 Features

- *(zsh)* Add fzf themes (Gouranga Das Samrat)
## [0.22.0] - 2026-02-22

### 🚀 Features

- *(zsh)* Improve archive.zsh functions (Gouranga Das Samrat)
## [0.21.0] - 2026-02-22

### 🚀 Features

- *(tools)* Add fzf to common packages (Gouranga Das Samrat)
## [0.20.0] - 2026-02-22

### 🚀 Features

- *(vscode)* Add C++ snippets for CP and LeetCode (Gouranga Das Samrat)

### 📚 Documentation

- Update README with new structure and scripts (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Improve script formatting and consistency (Gouranga Das Samrat)
## [0.19.0] - 2026-02-21

### 🚀 Features

- Add installation script (Gouranga Das Samrat)
## [0.18.0] - 2026-02-21

### 🚀 Features

- Add setup scripts for dotfiles and packages (Gouranga Das Samrat)
## [0.17.0] - 2026-02-21

### 🚀 Features

- *(scripts)* Improve setup script functionality (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Remove git-lfs from install_tools.sh (Gouranga Das Samrat)
- *(scripts)* Add Go tools installation script (Gouranga Das Samrat)
- Remove install_tools.sh and .stow-local-ignore (Gouranga Das Samrat)
## [0.16.0] - 2026-02-20

### 🚀 Features

- *(install)* Clone and manage wallpapers (Gouranga Das Samrat)

### 📚 Documentation

- Update VS Code extension name (Gouranga Das Samrat)
- Add VS Code extensions list (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Add jq to common install tools (Gouranga Das Samrat)
- Add git-lfs to install script (Gouranga Das Samrat)
## [0.15.0] - 2026-02-20

### 🚀 Features

- *(keybindings)* Add shortcut for focus myView (Gouranga Das Samrat)
## [0.14.1] - 2026-02-20

### 🐛 Bug Fixes

- *(settings)* Hide empty editor hint and add word (Gouranga Das Samrat)
## [0.14.0] - 2026-02-16

### 🚀 Features

- *(install)* Add rofi to linux tools (Gouranga Das Samrat)

### 🚜 Refactor

- *(install)* Use case statement for OS detection (Gouranga Das Samrat)

### 📚 Documentation

- Improve README with table of contents and detailed sections (Gouranga Das Samrat)
- Remove outdated diagrams and roadmap (Gouranga Das Samrat)
- Remove Table of Contents from README (Gouranga Das Samrat)
- Add Rofi and Build Essential to Linux tools (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Add build-essential to linux tools (Gouranga Das Samrat)
## [0.13.0] - 2026-02-16

### 🚀 Features

- *(install)* Organize tools by OS (Gouranga Das Samrat)
## [0.12.1] - 2026-02-16

### 🐛 Bug Fixes

- Enable eslint formatting on save (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Improve script execution and error handling (Gouranga Das Samrat)
- Refactor install_tools.sh for clarity (Gouranga Das Samrat)
- Fix formatting in zsh utility scripts (Gouranga Das Samrat)
## [0.12.0] - 2026-02-15

### 🚀 Features

- *(scripts)* Improve error handling and git hooks setup in install script (Gouranga Das Samrat)

### 📚 Documentation

- Enhance README with features and installation details (Gouranga Das Samrat)
## [0.11.0] - 2026-02-15

### 🚀 Features

- *(scripts)* Add script selector and runner (Gouranga Das Samrat)

### 💼 Other

- Add script to install Go tools (Gouranga Das Samrat)
## [0.10.0] - 2026-02-15

### 🚀 Features

- *(scripts)* Add tool installation script (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- Update commit-msg hook and VS Code settings (Gouranga Das Samrat)
- Configure git fetch and push defaults (Gouranga Das Samrat)
## [0.9.0] - 2026-02-13

### 🚀 Features

- *(git)* Add Conventional Commits hook (Gouranga Das Samrat)

### 📚 Documentation

- Update extensions list and add backend profile (Gouranga Das Samrat)
- Update extensions list (Gouranga Das Samrat)

### 🎨 Styling

- *(alacritty)* Decrease font size (Gouranga Das Samrat)
- *(zsh-starship)* Update prompt accent color (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(dotfiles)* Update various configurations (Gouranga Das Samrat)
- *(vscode)* Add keybinding: toggle panel (Gouranga Das Samrat)
- *(vscode)* Update settings and add snippets (Gouranga Das Samrat)
- Chore: Update VS Code settings
- Changed hover and suggestion delays
- Disabled ESLint format on save
- Increased auto save delay
- Switched CommitSage model (Gouranga Das Samrat)
## [0.8.0] - 2026-01-28

### 🚀 Features

- *(alacritty)* Add Alacritty config with Dracula theme (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Update shell configuration with new alias for vs code's golang dev profile (Gouranga Das Samrat)

### 📚 Documentation

- *(vscode)* Update extensions list for Go development (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(vscode)* Add clang format global snippet (Gouranga Das Samrat)
- *(zsh)* Add new alias (Gouranga Das Samrat)
- Chore(vscode: add new cspell words,and new keybindings for next and prev error (Gouranga Das Samrat)
## [0.7.0] - 2026-01-25

### 🚀 Features

- *(vscode)* Configure Go Dev profile and Prettier defaults (Gouranga Das Samrat)

### ⚙️ Miscellaneous Tasks

- *(git)* Enable UI colors (Gouranga Das Samrat)
## [0.6.0] - 2026-01-24

### 🚀 Features

- *(git)* Add personal git configuration (Gouranga Das Samrat)

### 🚜 Refactor

- *(zsh)* Reorganize config and add utils (Gouranga Das Samrat)

### 📚 Documentation

- Add VS Code extensions list (Gouranga Das Samrat)
- Rewrite README and add MIT license (Gouranga Das Samrat)
## [0.5.0] - 2026-01-23

### 🚀 Features

- *(vscode)* Add personal configuration files (Gouranga Das Samrat)
## [0.4.0] - 2026-01-23

### 🚀 Features

- *(tmux)* Add comprehensive tmux configuration (Gouranga Das Samrat)
## [0.3.0] - 2026-01-23

### 🚀 Features

- *(rofi)* Add Rofi configuration (Gouranga Das Samrat)
## [0.2.0] - 2026-01-23

### 🚀 Features

- *(zsh)* Add comprehensive shell customizations (Gouranga Das Samrat)
## [0.1.0] - 2026-01-23

### 💼 Other

- Initial commit (Gouranga Das Samrat)
