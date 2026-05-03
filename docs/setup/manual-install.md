# Manual Install Guide

A quick reference for installing essential developer tools manually.

---

## Homebrew (macOS)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

## C Compiler

### GCC (Linux / Termux)

**Debian/Ubuntu:**

```bash
sudo apt-get install build-essential
```

**Fedora/CentOS/RHEL:**

```bash
sudo dnf groupinstall "Development Tools"
```

**Termux:**

```bash
apt install build-essential
```

### Clang (macOS / Linux / Termux)

**macOS (with Xcode):**

```bash
xcode-select --install
```

**Linux (Debian/Ubuntu):**

```bash
sudo apt-get update
sudo apt-get install clang
```

**Linux (Fedora/CentOS/RHEL):**

```bash
sudo dnf install clang
```

**Termux:**

```bash
apt install clang
```

---

## Go

**macOS / Linux:**

1. Download the latest tarball from [https://go.dev/dl](https://go.dev/dl)
2. Extract and install:

```bash
tar -C /usr/local -xzf go1.x.x.linux-amd64.tar.gz
```

3. Extract done.

---

**Termux:**

```bash
apt install golang
```

---

## uv (Python package manager)

**macOS / Linux:**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

**Termux:**

```bash
apt install uv
```

---

## Rust

**macOS / Linux:**

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

---

**Termux:**

```bash
apt install rust
```

---

## nvm

**macOS / Linux:**

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

### Install Node 24

```bash
nvm install 24
```

---

## pnpm

```bash
corepack enable pnpm
```

---

## Bun

**macOS / Linux:**

```bash
curl -fsSL https://bun.sh/install | bash
```

---

> **Note:** Some installers auto-append lines to your shell config (`~/.bashrc`, `~/.zshrc`, etc.). Since you already have PATH configured, check for duplicates after install and remove them.
