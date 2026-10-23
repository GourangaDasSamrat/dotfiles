# Installed Software

Everything the installer adds, and how the scripts are organised. The package
lists live in
[`scripts/utils/software_lists.sh`](https://github.com/GourangaDasSamrat/dotfiles/blob/main/scripts/utils/software_lists.sh).

## Package lists

|                          |                                                                                                                                                                                                                                                                                                                                                  |
| :----------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **everywhere**           | curl · wget · jq · httpie · openssl · fd · ripgrep · fzf · eza · bat · duf · bash-completion · shfmt · shellcheck · just · moreutils · stow · gh · git-lfs · git-delta · pass                                                                                                                                                                    |
| **linux extras**         | clang · llvm · zsh · rofi · 7zip                                                                                                                                                                                                                                                                                                                 |
| **debian / ubuntu**      | build-essential · command-not-found · starship                                                                                                                                                                                                                                                                                                   |
| **fedora / rhel**        | development-tools · openssl-devel · PackageKit-command-not-found · helix                                                                                                                                                                                                                                                                         |
| **arch**                 | base-devel · rustup · cargo-binstall · uv · bun · fnm · docker · biome · go · golangci-lint · gopls · opencode · cloudflared · pkgfile · starship · helix · ghostty                                                                                                                                                                              |
| **macOS**                | rustup · cargo-binstall · uv · bun · fnm · biome · llvm · go · goimports · golangci-lint · gopls · go-air · opencode · docker · colima · sccache · cloudflared · usql · starship · helix                                                                                                                                                         |
| **macOS apps**           | vs code · ghostty · bruno · dbeaver · firefox · notion · discord · iina · raycast · alt-tab · hiddenbar · pinentry-mac · JetBrains Mono Nerd Font                                                                                                                                                                                                |
| **termux**               | build-essential · nodejs-lts · bun · uv · biome2 · usql · golang · gopls · goimports · golangci-lint · air · rust · cargo-binstall · rust-analyzer · firefox · code-oss · bruno · ghostty · mousepad · eog · galculator · starship · helix · helix-grammars · gtrash · cloudflared · xdg-utils · openssl-tool · mpv-x · python-yt-dlp |
| **go tools** _(opt)_     | goimports · gopls · golangci-lint · govulncheck · gotests · air · goreleaser · usql · eget · sheets · gtrash                                                                                                                                                                                                                                     |
| **rust tools** _(opt)_   | cargo-watch · cargo-cache · cargo-dist · cargo-modules                                                                                                                                                                                                                                                                                           |
| **python tools** _(opt)_ | ytm-player _(via uv)_                                                                                                                                                                                                                                                                                                                            |

Packages that ship under different names (`fd` / `fd-find`, `bat` / `batcat`) are
matched automatically: whichever your distro has gets installed. Names above are
the package names each manager uses, so a few differ by platform (`golang` and
`biome2` on Termux, `go-air` on Homebrew). Termux also gets the _linux extras_.

## Scripts layout

```text
scripts/
├── install.sh              full automated setup (runs lib/ scripts)
├── setup.sh                interactive menu — pick and choose
│
├── lib/                    modular setup scripts (standalone)
│   ├── softwares.sh        install packages for your os and package manager
│   ├── wallpapers.sh       download the wallpaper collection
│   ├── fonts.sh            apple's SF Pro & SF Mono on linux (needs curl + 7z)
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
