# Functions

## API Request Builder (`apireq`) - [ARCHIVED]

⚠️ **This function is archived.** If you want to use it, move the file from the `archive/` folder to your desired location.

**Location:** `~/.config/zsh/functions/apireq.zsh`

Interactive CLI tool for building and sending HTTP requests.

```bash
apireq        # Launch interactive builder
apireq --help
```

### Interactive Steps

1. **Method** — GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS
2. **URL** — full endpoint URL
3. **Options** (multi-select) — Auth, Custom Headers, Query Params, Request Body
4. **Output format:**

| Format | Description                              |
| ------ | ---------------------------------------- |
| `bat`  | Full response with HTTP syntax highlight |
| `jq`   | Headers plain + body pretty-printed JSON |
| `auto` | bat for headers, jq if JSON else bat     |
| `raw`  | Unformatted response                     |

### Auth Options

- **Bearer Token** — `Authorization: Bearer <token>`
- **Basic Auth** — Base64-encoded `username:password`

### Request Body Types

| Type      | Content-Type                          |
| --------- | ------------------------------------- |
| JSON      | `application/json`                    |
| Raw Text  | `text/plain`                          |
| Form Data | `application/x-www-form-urlencoded`   |
| Multipart | `multipart/form-data` (`@` for files) |

### Saved Requests

Requests save as `.http` files in `~/.apireq/`. Format:

```http
POST http://localhost:4000/api/v1/users
Content-Type: application/json
Authorization: Bearer token123

{"name": "John", "email": "john@example.com"}
```

### Dependencies

- **Required:** `curl`, `fzf`
- **Optional:** `bat`, `jq`, `python3`

---

## AI Query (`ask`) - [ARCHIVED]

⚠️ **This function is archived.** If you want to use it, move the file from the `archive/` folder to your desired location.

**Location:** `~/.config/zsh/functions/ai.zsh`

Ask questions directly from the terminal using Google Gemini AI.

```bash
ask what is docker
ask "explain recursion simply"
```

### Setup

Store your Gemini API key using `pass`:

```bash
pass insert apps/key/genini
```

Then use `ask` to query Gemini with natural language questions.

### Response Format

Responses are displayed with a formatted border:

```
╭─ Answer
│ Your answer text here...
│ Multiline responses are supported
╰─
```

### Dependencies

- **Required:** `curl`, `jq`, `python3`, `pass`

---

## Archive (`extract` / `compress`)

**Location:** `~/.config/zsh/functions/archive.zsh`

### `extract`

```bash
extract file.tar.gz
extract archive.zip
```

Supports: `.tar`, `.tar.gz`/`.tgz`, `.tar.bz2`/`.tbz2`, `.tar.xz`/`.txz`, `.zip`

### `compress`

```bash
compress file.txt
compress my_folder/
```

Opens an FZF menu to pick a compression format:

| Format    | Compression | Notes             |
| --------- | ----------- | ----------------- |
| `tar.gz`  | Medium      | Good balance      |
| `tar.bz2` | High        | Slower            |
| `tar.xz`  | Very High   | Slowest           |
| `zip`     | Medium      | Cross-platform    |
| `7z`      | Very High   | High compression  |
| `gz`      | Low         | Single files only |
| `bz2`     | Medium      | Single files only |

### Dependencies

- **Required:** `tar`, `zip`/`unzip`, `fzf`
- **Optional:** `bzip2`, `xz`, `7z`

---

## Directory Hooks (`chpwd`)

**Location:** `~/.config/zsh/functions/chpwd.zsh`

Runs automatically on every directory change via `add-zsh-hook chpwd`.

### `_manage_python_venv`

Auto-activates/deactivates Python virtual environments. Detects `.venv`, `venv`, `.env` (in that priority order).

```bash
cd my_project   # Has .venv → activates automatically
cd ..           # Leaving project → deactivates automatically
```

### `_list_project_tools`

Detects and lists available automation commands in the current directory:

| File                 | Shows                            |
| -------------------- | -------------------------------- |
| `justfile`           | All Just recipes (`just --list`) |
| `Makefile`           | All Make targets                 |
| `package.json`       | npm/pnpm scripts                 |
| `docker-compose.yml` | Docker Compose services          |

Each tool only shows if both the config file and the binary exist.

> Docker Compose detection can be slow (~200–500ms). Disable it if not needed.

---

## Network (`isup` / `myip` / `inspect`)

**Location:** `~/.config/zsh/functions/network.zsh`

**Prerequisite:** `httpie` must be installed.

### `isup`

Checks if a domain is online.

```bash
isup example.com
isup https://example.com
```

Returns HTTP status and server header. Shows online ✔, issue ⚠, or offline ✘.

### `myip`

Displays your public IP, city, region, and ISP via `ipinfo.io`.

```bash
myip
```

Falls back to `grep` parsing if `jq` is not installed.

### `inspect`

Inspects HTTP headers and SSL certificate info for a domain.

```bash
inspect example.com
```

Shows: HTTP status, Server, Content-Type, X-Powered-By, Cache-Control, security headers, SSL validity dates.

### Dependencies

- **Required:** `httpie`
- **Optional:** `openssl` (SSL info), `jq` (JSON parsing)

---

## Security (GPG Auto-Lock)

**Location:** `~/.config/zsh/functions/security.zsh`

Starts a background process that locks the GPG vault every 15 minutes.

```bash
if ! pgrep -f "gpg-auto-lock-loop" > /dev/null; then
  (exec -a gpg-auto-lock-loop bash -c '
    trap "exit" SIGTERM
    while true; do
      sleep 900
      gpg-connect-agent reloadagent /bye > /dev/null 2>&1
    done
  ') &
  disown
fi
```

Only one instance runs at a time. To adjust the lock interval, change `sleep 900` (seconds).

### Related Commands

```bash
lock-vault                      # Lock immediately
pgrep -a "gpg-auto-lock-loop"  # Check if running
pkill -f "gpg-auto-lock-loop"  # Kill the process
```

### GPG Agent Timeout (`~/.gnupg/gpg-agent.conf`)

```bash
default-cache-ttl 600   # 10 minutes
max-cache-ttl 7200      # 2 hours
```

---

## Utils (`serve` / `timer` / `shd`)

**Location:** `~/.config/zsh/functions/utils.zsh`

### `serve`

Starts a Python HTTP server with port validation.

```bash
serve           # Prompts for port (default: 8000)
serve 8080
serve -b        # Bind to 0.0.0.0 (network-wide), prompts for port
serve 8080 -b   # Bind to 0.0.0.0 on port 8080
```

Validates that the port is numeric, in range (1–65535), and not already in use. The `-b` / `--bind-all` flag exposes the server on all network interfaces instead of localhost only.

### `timer`

Countdown timer with progress bar and color feedback.

```bash
timer 30         # 30 seconds
timer 2m         # 2 minutes
timer 1h30m      # 1 hour 30 minutes
timer 1h30m45s   # Combined
```

Progress bar changes color: green (>50%), orange (25–50%), red (<25%). Press `Ctrl+C` to stop and restore the terminal.

### `shd`

Scans and displays large build/dependency folders recursively.

```bash
shd              # Scan home directory (default)
shd /path/to/dir # Scan specific directory
shd . 500        # Scan current dir, only show >= 500 MB
```

**Parameters:**

- `$1` — Root directory to scan (default: `$HOME`)
- `$2` — Minimum size filter in MB (default: `0`, no filter)

**Targets Scanned:**

Detects and displays size of common build and dependency folders:

| Category       | Folders                                                                      |
| -------------- | ---------------------------------------------------------------------------- |
| Node.js        | `node_modules`, `.pnp`                                                       |
| Rust           | `target`                                                                     |
| PHP            | `vendor`, `pkg`                                                              |
| Python         | `.venv`, `venv`, `__pycache__`, `.eggs`, `dist-packages`, `site-packages`    |
| .NET           | `bin`, `obj`                                                                 |
| Java/Gradle    | `build`, `.gradle`, `out`                                                    |
| Ruby           | `bundle`                                                                     |
| Frontend Build | `dist`, `.next`, `.nuxt`, `.cache`, `.parcel-cache`, `.turbo`, `.svelte-kit` |

**Output Format:**

Displays results as a formatted table:

```
Size      Folder Name          Parent Path
────────────────────────────────────────
  4.2G    node_modules         /path/to/project
  1.8G    target               /path/to/rust-project
```

Color coding:

- Green: under 1GB
- Orange/Yellow: 200MB–1GB
- Red: 1GB and above

**Examples:**

```bash
shd                    # Scan $HOME, show all
shd ~/projects         # Scan ~/projects directory
shd . 100              # Current dir, only >= 100 MB
shd /var/tmp 500       # Scan /var/tmp, only >= 500 MB
```

### Dependencies

- **Required:** `du` (standard Unix utility)
- **Optional:** Color support (built-in zsh colors)

---

## WHOIS (`dzw`)

**Location:** `~/.config/zsh/functions/whois.zsh`

Domain WHOIS lookup with multiple server options.

```bash
dzw example.com          # Default server
dzw com example.com      # Via .com registry
dzw dp example.com       # Via DigitalPlat
dzw iana example.com     # Via IANA
```

| Key    | Server                 |
| ------ | ---------------------- |
| `dp`   | whois.digitalplat.org  |
| `iana` | whois.iana.org         |
| `com`  | whois.verisign-grs.com |

Output is filtered to key fields: Domain Name, Registrar, Creation Date, Expiry Date, Registrant info, Name Servers, Domain Status.

Add custom servers by editing the `WHOIS_SERVERS` map in `dzw()`.
