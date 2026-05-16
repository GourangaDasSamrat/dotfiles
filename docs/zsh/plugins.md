# Plugins

## FZF

**Location:** `~/.config/zsh/plugins/fzf.zsh`

Configures FZF with themes, key bindings, and enhanced tab completion via `fzf-tab`.

### Themes

Two themes available — switch by changing the function call in `fzf.zsh`:

```bash
_fzf_theme_dracula      # Active (dark, vibrant)
_fzf_theme_catppuccin   # Alternative (warm, pastel)
```

### Key Bindings

| Key      | Action                   |
| -------- | ------------------------ |
| `Ctrl+T` | Fuzzy file picker        |
| `Ctrl+R` | Search command history   |
| `Alt+C`  | Fuzzy `cd`               |
| `Tab`    | FZF-powered tab complete |

### Preview

- **Directories** — tree view via `eza`
- **Files** — first 500 lines via `bat` (syntax highlighted)
- **`cd`** — directory tree
- **`export`/`unset`** — variable value
- **`ssh`** — DNS lookup via `dig`

### FZF-Tab

Applies FZF theme and preview to tab completion. Use `<`/`>` to switch completion groups.

### Dependencies

- **Required:** `fzf`, `fd`
- **Preview:** `eza`, `bat`

---

## Pass (Password Manager Integration)

**Location:** `~/.config/zsh/plugins/pass.zsh`

Saves and loads `.env` files using GPG-encrypted `pass` storage.

### `env-save`

```bash
env-save .env myproject/env
env-save .env.local secrets/myapp-dev
```

Saves a local file into the `pass` store using multi-line mode.

### `env-load`

```bash
env-load myproject/env              # Loads to .env
env-load myproject/env .env.local   # Loads to custom file
```

Decrypts and writes the pass entry to a local file.

Both commands are excluded from shell history. `.env` files should be `chmod 600` and added to `.gitignore`.

### Dependencies

- `pass`, `gpg`

### Setup

```bash
gpg --gen-key
pass init "your@email.com"
```
