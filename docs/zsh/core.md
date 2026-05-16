# Core Modules

## Colors

**Location:** `~/.config/zsh/core/colors.zsh`

Defines a shared ANSI 256-color palette used across all modules.

| Variable        | Color     | Purpose                          |
| --------------- | --------- | -------------------------------- |
| `COLOR_HEADER`  | Purple    | Headers, prompts, section titles |
| `COLOR_CURSOR`  | Cyan      | Cursor, selected items           |
| `COLOR_SUCCESS` | Green     | Success messages                 |
| `COLOR_ERROR`   | Red       | Error messages                   |
| `COLOR_WARNING` | Orange    | Warnings                         |
| `COLOR_NORMAL`  | Gray      | Secondary info                   |
| `COLOR_TEXT`    | White     | Important text                   |
| `COLOR_BORDER`  | Dark Gray | Borders, separators              |
| `COLOR_RESET`   | —         | Reset to terminal default        |

```bash
_init_colors() {
  export COLOR_HEADER=$'\033[38;5;141m'
  export COLOR_CURSOR=$'\033[38;5;49m'
  export COLOR_SUCCESS=$'\033[38;5;77m'
  export COLOR_ERROR=$'\033[38;5;204m'
  export COLOR_WARNING=$'\033[38;5;208m'
  export COLOR_NORMAL=$'\033[38;5;246m'
  export COLOR_TEXT=$'\033[38;5;255m'
  export COLOR_BORDER=$'\033[38;5;240m'
  export COLOR_RESET=$'\033[0m'
}
_init_colors
```

Always end colored output with `$COLOR_RESET` to prevent color bleed.

### Usage Examples

```bash
echo "${COLOR_SUCCESS}✓${COLOR_RESET} Operation successful"
echo "${COLOR_ERROR}✗${COLOR_RESET} Operation failed"
echo "${COLOR_WARNING}⚠${COLOR_RESET} Warning message"
echo "${COLOR_HEADER}Section Header${COLOR_RESET}"
echo "${COLOR_BORDER}────────────${COLOR_RESET}"
```

### ANSI 256-Color Reference

- **0–15** — Standard colors
- **16–231** — RGB color cube (216 colors)
- **232–255** — Grayscale (24 shades)

```bash
# Display all 256 colors
for i in {0..255}; do
  printf "\033[38;5;${i}m%3d${COLOR_RESET} " "$i"
  if (( (i + 1) % 16 == 0 )); then echo; fi
done
```

---

## Environment

**Location:** `~/.config/zsh/core/env.zsh`

Sets up PATH and environment variables for development tools.

| Variable      | Value                 | Purpose                |
| ------------- | --------------------- | ---------------------- |
| `EDITOR`      | `hx`                  | Default editor (Helix) |
| `VISUAL`      | `$EDITOR`             | Visual editor          |
| `PAGER`       | `less`                | Default pager          |
| `BAT_THEME`   | `Dracula`             | bat syntax theme       |
| `DOTFILES`    | `$HOME/dotfiles`      | Dotfiles location      |
| `BUN_INSTALL` | `$HOME/.bun`          | Bun installation path  |
| `NVM_DIR`     | `$HOME/.nvm`          | Node Version Manager   |
| `PNPM_HOME`   | `~/.local/share/pnpm` | pnpm global location   |
| `GOPATH`      | `$HOME/go`            | Go workspace           |

PATH additions include: `~/.local/bin`, `$GOPATH/bin`, `$BUN_INSTALL/bin`, `$PNPM_HOME`, Homebrew, and Go binaries.

> NVM can slow shell startup. Consider `fnm` or `asdf` as faster alternatives.

### Termux (Android) Only

```bash
export SSL_CERT_FILE=/data/data/com.termux/files/usr/etc/tls/cert.pem
export BUN_OPTIONS="--os=android"
```

---

## History

**Location:** `~/.config/zsh/core/history.zsh`

```bash
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
```

### Sensitive Command Filtering

A `zshaddhistory` hook blocks commands from being saved based on prefixes, substrings, and patterns.

**Blocked prefixes:** `pass`, `op`, `bw`, `gpg`, `ssh-keygen`, `openssl`, `curl`, `wget`, `mysql -p`, `psql`, `redis-cli`, `docker login`, `gh auth`, `git remote set-url`, `usql`, `env-load`, `env-save`

**Blocked substrings:** `password`, `secret`, `api_key`, `access_token`, `bearer`, `private_key`, `database_url`, `aws_secret`, `stripe_key`, and others

**Blocked patterns:** `export *=*`, `[A-Z]*=*`, `*authorization*`, `*://*:*@*`, `*--password*`, `*--token*`, `*--secret*`

Commands starting with a space are also excluded via `hist_ignore_space`.

### Manual History Management

```bash
history          # Show all
history 50       # Last 50
history | grep name
> ~/.zsh_history  # Clear file
history -c        # Clear in-memory
```
