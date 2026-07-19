# Manual Install Guide

A quick reference for installing essential developer tools manually.

---

## Xcode Command Line Tools (macOS)

Required before Homebrew, and also provides Clang. Run once:

```bash
xcode-select --install
```

---

## Homebrew (macOS)

| Requires          | Command                                                                                           |
| ----------------- | ------------------------------------------------------------------------------------------------- |
| Xcode CLT (above) | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` |

---

## C Compiler

macOS: already covered by Xcode CLT above, nothing extra needed.

| Platform           | Compiler | Command                                     |
| ------------------ | -------- | ------------------------------------------- |
| Debian/Ubuntu      | GCC      | `sudo apt-get install build-essential`      |
| Fedora/CentOS/RHEL | GCC      | `sudo dnf groupinstall "Development Tools"` |
| Termux             | GCC      | `apt install build-essential`               |

---

## Go

| Platform               | Command                                                                                                        |
| ---------------------- | -------------------------------------------------------------------------------------------------------------- |
| macOS (brew)           | `brew install go`                                                                                              |
| macOS / Linux (manual) | Download tarball from [go.dev/dl](https://go.dev/dl), then `tar -C /usr/local -xzf go1.x.x.linux-amd64.tar.gz` |
| Termux                 | `apt install golang`                                                                                           |

---

## uv (Python package manager)

| Platform      | Command                                            |
| ------------- | -------------------------------------------------- |
| macOS (brew)  | `brew install uv`                                  |
| macOS / Linux | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Termux        | `apt install uv`                                   |

---

## Rust

Even via brew, install `rustup` (the toolchain manager) — not the `rust` formula directly.

| Platform               | Command                                                           |
| ---------------------- | ----------------------------------------------------------------- |
| macOS (brew)           | `brew install rustup-init && rustup-init`                         |
| macOS / Linux (manual) | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| Termux                 | `apt install rust`                                                |

After install:

```bash
rustup update
rustup toolchain install stable
```

---

## Node.js

| Platform      | Command                                             |
| ------------- | --------------------------------------------------- |
| macOS (brew)  | `brew install fnm`                                  |
| macOS / Linux | `curl -fsSL https://fnm.vercel.app/install \| bash` |

Install Node.js:

```bash
fnm install --lts       # latest LTS
fnm use --lts
fnm default lts-latest

# or a specific version
fnm install 20
fnm use 20
```

---

## Bun

| Platform      | Command                                                                                                                             |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| macOS (brew)  | `brew tap oven-sh/bun && brew install bun`                                                                                          |
| macOS / Linux | `curl -fsSL https://bun.sh/install \| bash`                                                                                         |
| Termux        | `curl -fsSL "https://raw.githubusercontent.com/Happ1ness-dev/bun-termux/main/helper_scripts/bun-termux-manager" \| bash -s install` |

---

## Mongosh

| Platform                         | Command                        |
| -------------------------------- | ------------------------------ |
| macOS (brew)                     | `brew install mongosh`         |
| macOS / Linux / Termux (via Bun) | `bun add -g @mongosh/cli-repl` |

---

> **Note:** Some installers append lines to your shell config (`~/.bashrc`, `~/.zshrc`, etc.) — including `fnm env` and `rustup`/`cargo` PATH exports. Since you already manage your shell config yourself, check for duplicate entries after each install and remove them.
