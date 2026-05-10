# Helix Language Servers, Formatters & Linters

Install guide for all tools configured in `helix/languages.toml`.

## Prerequisites

- Node.js (via nvm)
- Rust (via rustup)
- Go

### Termux

If on Termux, install tree-sitter grammars:

```bash
apt install helix-grammars
```

---

## Bash / Shell

**Language server:**

```bash
npm install -g bash-language-server
```

**Formatter:**

Debian/Ubuntu:

```bash
sudo apt install shfmt
```

Termux:

```bash
apt install shfmt
```

macOS:

```bash
brew install shfmt
```

---

## HTML

```bash
npm install -g vscode-langservers-extracted
```

Provides `vscode-html-language-server`.

---

## CSS

```bash
npm install -g vscode-langservers-extracted
```

Provides `vscode-css-language-server`. Skip if already installed for HTML.

---

## TypeScript / JavaScript

**Language server:**

```bash
npm install -g typescript-language-server
```

**Formatter & Linter:**

```bash
npm install -g eslint prettier
```

---

## Rust

**macOS/Debian/Ubuntu**

```bash
rustup component add rust-analyzer clippy
```

**Termux**

```bash
apt install rust-analyzer
```

---

## Go

**Language server:**

```bash
go install golang.org/x/tools/gopls@latest
```

**Formatter:**

```bash
go install golang.org/x/tools/cmd/goimports@latest
```

**Linter:**

```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

---

## Lua

**Debian/Ubuntu:**

```bash
sudo apt install lua-language-server
```

**macOS:**

```bash
brew install lua-language-server
```

**Termux:**

```bash
apt install lua-language-server
```

---

## Markdown

**macOS:**

```bash
brew install marksman
```

**Debian/Ubuntu:**

```bash
sudo apt install marksman
```

**Termux:**

```bash
apt install marksman
```

---

## JSON

```bash
npm install -g vscode-langservers-extracted
```

Provides `vscode-json-language-server`. Skip if already installed above.

---

## TOML

```bash
cargo install taplo-cli --locked
```

---

## YAML

```bash
npm install -g yaml-language-server
```

---

## SQL

**Language server:**

```bash
npm install -g sql-language-server
```

**Formatter:**

```bash
npm install -g sql-formatter
```

---

## Verify

Check all language servers are detected by Helix:

```bash
hx --health
```

Check a specific language:

```bash
hx --health rust
hx --health go
hx --health typescript
```
