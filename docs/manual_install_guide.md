# Manual Install Guide

A quick reference for installing essential developer tools manually.

---

## Homebrew (macOS)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

## uv (Python package manager)

**macOS / Linux:**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

## Rust

**macOS / Linux:**

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
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
