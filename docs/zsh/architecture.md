# Architecture

## `.zshenv`

**Location:** `~/.zshenv`

Sets environment variables before any other ZSH file is sourced, making them available in all shell types.

```bash
export ZDOTDIR="$HOME/.config/zsh"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
```

- `ZDOTDIR` — redirects ZSH config files to `~/.config/zsh` to keep `~` clean
- Cargo env — loads Rust toolchain if available

> Keep this file minimal. No aliases or functions here — those go in `.zshrc`.

---

## `.zshrc`

**Location:** `~/.config/zsh/.zshrc`

Main config file. Loads in this order:

1. GPG TTY setup
2. Oh-My-Zsh + plugins
3. Starship prompt
4. All custom modules
5. Session start message
6. Local secrets

### Oh-My-Zsh

```bash
export ZSH="$HOME/.oh-my-zsh"
ZSH_COMPDUMP=$HOME/.cache/zsh/zcompdump
ZSH_THEME=""
plugins=(git fzf zsh-autosuggestions zsh-syntax-highlighting fzf-tab)
[[ -d "$ZSH" ]] && source "$ZSH/oh-my-zsh.sh"
```

### Module Loading Order

```bash
zsh_modules=(
  core/env
  core/colors
  core/history
  functions/utils
  functions/archive
  functions/chpwd
  plugins/fzf
  plugins/pass
  user/aliases
  functions/security
  user/overrides
  functions/whois
  functions/network
)
```

Missing modules show a warning but don't break the shell.

### Secrets Loading

```bash
if [[ -f "$HOME/.zsh_secrets" ]]; then
  [[ "$(stat -c %a ...)" != "600" ]] && echo "⚠️  ~/.zsh_secrets is not chmod 600" >&2
  source "$HOME/.zsh_secrets"
fi
```

Warns if `~/.zsh_secrets` isn't `chmod 600` before sourcing it.
