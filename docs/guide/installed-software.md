# Installed Software

Everything the installer adds, and how the scripts are organised. The package
lists live in
[`scripts/utils/software_lists.sh`](https://github.com/GourangaDasSamrat/dotfiles/blob/main/scripts/utils/software_lists.sh).

## Package lists

|                          |                                                                                                                                                                                                  |
| :----------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **everywhere**           | curl · wget · jq · httpie · openssl · fd · ripgrep · fzf · eza · bat · duf · bash-completion · shfmt · shellcheck · just · moreutils · stow · gh · git-lfs · git-delta · pass · starship · helix |
| **linux extras**         | clang · llvm · zsh · rofi                                                                                                                                                                        |
| **build tools**          | build-essential / base-devel _(apt, pacman)_ · development-tools + openssl-devel _(dnf)_                                                                                                         |
| **arch**                 | rustup · cargo-binstall · uv · bun · fnm · docker · biome · go · golangci-lint · gopls · cloudflared · pkgfile                                                                                   |
| **macOS**                | rustup · cargo-binstall · uv · bun · fnm · biome · go · goimports · golangci-lint · gopls · air · docker · colima · sccache · cloudflared · usql                                                 |
| **macOS apps**           | vs code · kitty · bruno · tableplus · zen · notion · discord · iina · raycast · alt-tab · hiddenbar · pinentry-mac · JetBrains Mono Nerd Font                                                    |
| **termux**               | build-essential · nodejs · bun · uv · biome · usql · go + tools · rust + rust-analyzer · cloudflared · code-oss · zen-browser · mpv · yt-dlp · gtrash · mousepad · eog · galculator              |
| **go tools** _(opt)_     | goimports · gopls · golangci-lint · govulncheck · gotests · air · goreleaser · usql · eget · sheets · gtrash                                                                                     |
| **rust tools** _(opt)_   | cargo-watch · cargo-cache · cargo-dist · cargo-modules                                                                                                                                           |
| **python tools** _(opt)_ | ytm-player _(via uv)_                                                                                                                                                                            |

Packages that ship under different names (`fd` / `fd-find`, `bat` / `batcat`) are
matched automatically: whichever your distro has gets installed.

## Scripts layout

```text
scripts/
├── install.sh              full automated setup (runs lib/ scripts)
├── setup.sh                interactive menu — pick and choose
│
├── lib/                    modular setup scripts (standalone)
│   ├── softwares.sh        install packages for your os and package manager
│   ├── wallpapers.sh       download the wallpaper collection
│   ├── fonts.sh            apple's SF Pro & SF Mono on linux (needs wget + 7z)
│   └── dotfiles.sh         symlink configs with gnu stow
│
├── sdk-tools/              optional language-specific installers
│   ├── cargo-tools.sh      rust cli tools (cargo-watch, cargo-cache, etc.)
│   ├── go-tools.sh         go dev tools (gopls, golangci-lint, goreleaser, etc.)
│   └── uv-tools.sh         python cli tools via uv package manager
│
├── utils/
│   ├── detect.sh           os · package manager · sudo detection
│   └── software_lists.sh   package lists per os, distro and environment
│
└── config/
    └── wallpapers.url      wallpapers list, one url per line
```

Every script in `lib/` and `sdk-tools/` runs standalone, so source only what you
need. How to run them is covered in [Getting Started](./getting-started).
