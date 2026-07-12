# Customization

## User Aliases

**Location:** `~/.config/zsh/user/aliases.zsh`

### Navigation

| Alias    | Command                |
| -------- | ---------------------- |
| `dot`    | `cd $DOTFILES`         |
| `dots`   | `cd $DOTFILES/scripts` |
| `reload` | Re-source `.zshrc`     |

### Safety

| Alias        | Behavior                       |
| ------------ | ------------------------------ |
| `cp`         | `cp -iv` — confirm + verbose   |
| `mv`         | `mv -iv` — confirm + verbose   |
| `afk`        | Lock vault, clear screen, exit |
| `lock-vault` | Immediately lock GPG vault     |

### Eza (`ls` replacement)

| Alias | Flags                             |
| ----- | --------------------------------- |
| `ls`  | Long format with git + icons      |
| `lt`  | Tree view, excluding node_modules |
| `la`  | Show all files (except `.` `..`)  |

### VS Code Profiles

| Alias    | Profile      |
| -------- | ------------ |
| `code-b` | Backend Dev  |
| `code-f` | Frontend Dev |
| `code-r` | Rust Dev     |
| `code-g` | Go Dev       |
| `code-c` | C/C++ Dev    |
| `code-d` | Database Dev |
| `code-l` | Lua Dev      |
| `code-w` | Wiki Dev     |

### Language Aliases

**Go:** `gr` (run), `gb` (build), `gmod` (mod)

**Cargo:** `cr` (run), `cb` (build), `ct` (test), `cc` (check), `cn` (new), `ccl` (clean), `cdoc` (doc --open)

**GitHub CLI:** `ght` (today), `ghm` (this month), `ghy` (this year), `ghyy` (yesterday), `ghlm` (last month), `ghstr` (streak), `ghp` (PRs), `gho` (open in browser)

All aliases use `(($+commands[name]))` — only defined if the binary is installed.

### Termux-Only

| Alias    | Purpose                    |
| -------- | -------------------------- |
| `debian` | Login to Debian proot      |
| `lf`     | Navigate to Debian home    |
| `af`     | Navigate to shared storage |
| `start`  | Run startup script         |

### Managing Aliases

```bash
alias              # List all
alias | grep code  # Filter by pattern
reload             # Apply changes
```

---

## Command Overrides

**Location:** `~/.config/zsh/user/overrides.zsh`

### `mkdir`

Enhanced with auto `-p` flag and optional git initialization on single-directory creation.

```bash
mkdir newproject      # Creates dir + prompts for git init
mkdir dir1 dir2 dir3  # Creates all, no git prompt
```

If **Yes** to git init: creates `README.md`, makes initial commit `chore: initialize repository with README`.

### `rm`

Confirmation screen before any deletion, with file/folder type icons.

```bash
rm file.txt       # Shows confirmation
rm -r folder      # Flags are preserved
rm *.log          # Confirms all matches
```

Shows a list of items with 📁/📄 icons, then prompts `[Y/n] Delete?`.

To bypass either override:

```bash
command mkdir newdir
/bin/rm file.txt
```

---

## Starship Prompt

**Location:** `~/.config/starship.toml`

Cross-shell prompt written in Rust (~1ms render time).

### Format

The prompt includes (in order): `$hostname`, `$directory`, `$localip`, `$shlvl`, `$kubernetes`, `$docker_context`, language modules, `$git_branch`, `$git_status`, `$git_commit`, `$cmd_duration`, `$jobs`, `$battery`, `$time`, `$status`, `$line_break`, `$character`

Language modules auto-show only when in a relevant project directory.

### Key Modules

**Hostname** — only shown over SSH

**Directory** — truncated to 1 level, read-only indicated with `󰌾`

**Character:**

- Success: `❯` in cyan (`#68f7d8`)
- Error: `❯` in red (`#B66467`)

**Git symbols:** `●` conflicted, `✓` staged, `+` added, `▲` renamed, `▼` deleted

### Colors

| Color      | Hex       | Use              |
| ---------- | --------- | ---------------- |
| Cyan       | `#68f7d8` | Accents, success |
| Red        | `#B66467` | Errors           |
| Light Gray | `#E8E3E3` | Text             |
| Dark Gray  | `#252525` | Background       |

Works identically across zsh, bash, fish, and PowerShell with the same config file.

Full docs: https://starship.rs/config/
