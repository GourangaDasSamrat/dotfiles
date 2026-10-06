# Getting Started

This page takes a fresh machine from nothing to a fully configured shell, editor
and git setup. Everything is driven by the scripts in
[`scripts/`](https://github.com/GourangaDasSamrat/dotfiles/tree/main/scripts).

## Requirements

| Requirement     | Notes                                                                  |
| --------------- | ---------------------------------------------------------------------- |
| `git`           | Needed to clone the repository.                                        |
| Homebrew        | macOS only — install from [brew.sh](https://brew.sh) first.            |
| `sudo`          | Used automatically for `apt`, `dnf` and `pacman` when it is available. |
| `wget` and `7z` | Linux only — the font installer downloads and unpacks Apple's DMGs.    |
| Internet access | Packages, fonts and wallpapers are downloaded during setup.            |

Supported package managers are detected in this order: `pkg` (Termux), `brew`,
`dnf`, `apt`, `pacman`. Anything else stops with
`Unsupported OS or package manager`.

## 1. Clone

The repository **must live at `~/dotfiles`**. GNU Stow links relative to the
parent directory, and the scripts and the `$DOTFILES` variable all assume this
path.

```bash
git clone https://github.com/GourangaDasSamrat/dotfiles.git ~/dotfiles
cd ~/dotfiles/scripts
```

## 2. Run the installer

Pick one of two modes.

::: code-group

```bash [Automated]
./install.sh
```

```bash [Interactive]
./setup.sh
```

:::

**`install.sh`** runs the whole setup in one go:

1. Updates the system and installs the package list for your platform.
2. Downloads the wallpaper collection into `~/Pictures/wallpapers` (skipped when
   the folder already exists).
3. Installs Apple's SF Pro and SF Mono into `~/.local/share/fonts` (Linux only).
4. Symlinks the configs with GNU Stow and marks the git hooks executable.

Optional language tools are **not** part of `install.sh`.

**`setup.sh`** lists every script (`install.sh`, `lib/*`, `sdk-tools/*`), lets you
type numbers like `1 3 4` or `all`, asks for confirmation, then runs each script
in its own shell and prints a pass/fail summary. Because each script runs
separately, one failure does not stop the others.

## What gets installed

The package list is built from shared lists plus one platform list. Every list
lives in
[`scripts/utils/software_lists.sh`](https://github.com/GourangaDasSamrat/dotfiles/blob/main/scripts/utils/software_lists.sh).

| Platform              | Lists combined                         |
| --------------------- | -------------------------------------- |
| macOS (`brew`)        | cross-platform + macOS                 |
| Termux (`pkg`)        | cross-platform + Linux common + Termux |
| Fedora (`dnf`)        | cross-platform + Linux common + RHEL   |
| Arch (`pacman`)       | cross-platform + Linux common + Arch   |
| Debian/Ubuntu (`apt`) | cross-platform + Linux common + Debian |

Some tools ship under different names depending on the distro. Entries written
as `fd|fd-find` or `bat|batcat` try each name until one installs, and anything
already installed is skipped, so re-running the installer is safe.

## 3. Optional language tools

Run these on their own once the toolchain exists. Add `--update` to force a
reinstall.

```bash
./sdk-tools/go-tools.sh       # gopls, golangci-lint, goreleaser, ... (needs go)
./sdk-tools/cargo-tools.sh    # cargo-watch, cargo-cache, ... (needs cargo)
./sdk-tools/uv-tools.sh       # ytm-player and friends (needs uv)
```

## 4. Start a new shell

The shell config lives in `~/.config/zsh` (`~/.zshenv` sets `ZDOTDIR`). Make zsh
your login shell if it is not already, then open a new terminal.

```bash
chsh -s "$(command -v zsh)"
exec zsh
```

On first launch the shell clones the [antidote](https://github.com/mattmc3/antidote)
plugin manager into `~/.antidote` and loads the plugins, so the first start is a
little slower than the rest.

## 5. Finish the personal setup

The installer cannot do these for you:

- **Secrets, `pass` and GPG** — required for signed commits and the push guard.
  See [Secrets, pass & GPG](./secrets).
- **Git identity** — `git/.gitconfig` carries the author's name, email and
  signing key. Override them as described in [Git Workflow](../git/workflow#identity-and-signing).
- **Opt-in configs** — Helix, Claude Code, rofi and others are not linked by
  default. See [GNU Stow](./stow#opt-in-packages).

## If the installer stops early

Every script in `lib/` runs standalone, so you can run the steps one by one and
see exactly which one fails:

```bash
./lib/softwares.sh
./lib/wallpapers.sh
./lib/fonts.sh        # Linux only, needs wget and 7z
./lib/dotfiles.sh
```

## Updating

```bash
cd ~/dotfiles
git pull
cd scripts && ./lib/softwares.sh   # pick up newly added packages
```

Because configs are symlinks, `git pull` updates them in place. Run `reload`
(or open a new terminal) to apply shell changes.
