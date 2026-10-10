---
title: Secrets, pass & GPG
---

Secrets never live in this repository. They are kept in
[`pass`](https://www.passwordstore.org/) (GPG-encrypted files) and read on demand.
Several parts of the setup depend on it, so do this once per machine.

| Piece                   | What it needs                                              |
| ----------------------- | ---------------------------------------------------------- |
| Signed commits          | A GPG key, referenced by `user.signingkey`                 |
| `pre-push` hook         | `pass git/push_pass`                                       |
| `git send-email`        | `pass app/gmail-smtp` (see [Send Email](/git/send-email/)) |
| `~/.zsh_secrets`        | Any `pass` entries you choose to load as env variables     |
| `env-save` / `env-load` | A working `pass` store                                     |

:::caution
Without `pass/git/push_pass`, **every `git push` fails**: the global `pre-push`
hook stops with `Could not retrieve passphrase from pass`. Set it up before your
first push, or see [Git Workflow](/git/workflow/#pre-push-guard).
:::

## 1. Create a GPG key

The installer adds `pass` (which normally pulls in GnuPG). The key itself is yours
to create.

```bash
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
```

Note the key ID or fingerprint from the second command. You need a
`pinentry` program for passphrase prompts. The installer adds `pinentry-mac` on
macOS; on Linux install one that suits your desktop (for example
`pinentry-gnome3` or `pinentry-curses`) and point `gpg-agent` at it:

```bash
echo "pinentry-program $(command -v pinentry-curses)" >> ~/.gnupg/gpg-agent.conf
gpg-connect-agent reloadagent /bye
```

`.zshrc` already exports `GPG_TTY`, which terminal-based pinentry needs.

## 2. Initialise the password store

```bash
pass init <your-gpg-key-id>
```

## 3. Store the push passphrase

The `pre-push` hook compares what you type against this entry:

```bash
pass insert git/push_pass
```

## 4. Point git at your key

The repository's `.gitconfig` hard-codes the author's identity and signing key.
Override them in `~/.gitconfig.local`, which is included last and therefore wins:

```ini
[user]
  name = Your Name
  email = you@example.com
  signingkey = YOUR_KEY_ID
```

Verify with:

```bash
git commit --allow-empty -m "chore: test signing"
git log --show-signature -1
```

## 5. Load secrets as environment variables

Copy the template and lock it down. The shell warns at startup if the file is
not `chmod 600`.

```bash
cp ~/dotfiles/docs/templates/.zsh_secrets.template ~/.zsh_secrets
chmod 600 ~/.zsh_secrets
```

Inside the file, each secret is one line, using the helper defined at the top of
the template:

```sh
# load_secret ENV_VAR_NAME  path/in/pass
load_secret GITHUB_TOKEN    github/token
```

`load_secret` reads the entry with `pass` and exports the variable, skipping it
silently if the entry is missing. The template also includes AWS helpers
(`aws-mock`, `aws-prod`) that are defined only when the `aws` CLI exists.

`~/.zsh_secrets` is sourced at the very end of `.zshrc`, so it can rely on
everything else being loaded.

## 6. Move `.env` files in and out of pass

For project `.env` files, use the two shell helpers:

```bash
env-save .env projects/myapp/env        # encrypt .env into pass (multi-line safe)
env-load projects/myapp/env             # write it back to ./.env
env-load projects/myapp/env .env.local  # ...or to another filename
```

`env-load` refuses to run when the entry does not exist, and prints how many
lines it wrote. Keep the resulting `.env` out of version control.

## Locking the vault

`pass` decrypts through `gpg-agent`, which caches your passphrase. Clear it when
you step away:

| Command      | Effect                                                         |
| ------------ | -------------------------------------------------------------- |
| `lock-vault` | Reloads `gpg-agent`, dropping the cached passphrase right away |
| `afk`        | `lock-vault`, clear the screen, then exit the shell            |

A background loop started by the shell also reloads the agent every 15 minutes,
so an idle session re-locks on its own.

## What the shell keeps out of history

`~/.zsh_history` skips commands that are likely to carry credentials. Anything
starting with `pass `, `gpg `, `openssl `, `curl `, `wget `, `psql `,
`gh auth`, `docker login`, `env-save` or `env-load` is not recorded, and neither
is any command containing words like `password`, `token`, `api_key` or
`secret`, `export VAR=...` assignments, URLs with embedded credentials, or
force-pushes. Prefix a command with a space to skip history manually.

## Troubleshooting

| Symptom                                               | Fix                                                                 |
| ----------------------------------------------------- | ------------------------------------------------------------------- |
| `gpg: signing failed: Inappropriate ioctl for device` | `export GPG_TTY=$(tty)` (already in `.zshrc`; check non-zsh shells) |
| `Could not retrieve passphrase from pass`             | `pass insert git/push_pass`                                         |
| `~/.zsh_secrets is not chmod 600`                     | `chmod 600 ~/.zsh_secrets`                                          |
| `pass` asks for a passphrase every time               | The agent cache expired or was locked; unlock once and retry        |
| `Error: 'pass' is not installed.`                     | Install `pass` with your package manager                            |
