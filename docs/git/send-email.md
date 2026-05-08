# Setting Up Git Send-Email

This guide covers configuring `git send-email` to send patch emails directly
from the command line using Gmail SMTP with credentials stored in `pass`.

## Prerequisites

- Git installed
- `pass` password manager configured
- A Gmail account with 2FA enabled

## 1. Install Git Send-Email

**Debian/Ubuntu:**

```bash
sudo apt install git-email
```

On macOS and termux, `git-email` is bundled with git — no separate package needed.

## 2. Install Required Perl Modules

```bash
cpan -i App::cpanminus
cpanm --notest Authen::SASL Net::SMTP::SSL MIME::Base64
```

The `--notest` flag skips running tests to speed up installation.

## 3. Create a Gmail App Password

1. Go to your Google Account settings
2. Navigate to Security → 2-Step Verification and enable it if not already on
3. Go to Security → App passwords
4. Select "Mail" and "Linux" (or "Other") and click Generate
5. Copy the 16-character password that appears

## 4. Store the Password in Pass

```bash
pass insert app/gmail-smtp
```

Paste your Gmail App Password when prompted.

> The `sendemail` config and the credential helper that pulls from pass are
> already set up in `git/.gitconfig`.

## 5. Usage

### Send a Single Patch

```bash
git format-patch -1 HEAD
git send-email --to recipient@example.com 0001-your-patch.patch
```

### Send Multiple Patches

```bash
git format-patch origin/main
git send-email --to recipient@example.com *.patch
```

### Send with a Cover Letter

```bash
git format-patch --cover-letter -3 HEAD
# edit the cover letter file
git send-email --to recipient@example.com *.patch
```

### Reply to an Existing Thread

```bash
git send-email \
  --in-reply-to="<message-id@mail.gmail.com>" \
  --to recipient@example.com \
  0001-patch.patch
```

## 6. Dry Run

Preview what will be sent without actually sending:

```bash
git send-email --dry-run --to recipient@example.com *.patch
```

## Troubleshooting

**"5.7.8 Username and Password not accepted" error:**

Verify your App Password is correctly stored in pass:

```bash
pass app/gmail-smtp
```

**"Cannot load Net::SMTP::SSL" error:**

```bash
cpanm --notest Net::SMTP::SSL
```

**TLS handshake error:**

```bash
git config --global sendemail.smtpsslverify false
```

Use this for debugging only — re-enable it afterwards.

## References

- [git send-email documentation](https://git-scm.com/docs/git-send-email)
- [Gmail App Passwords](https://support.google.com/accounts/answer/185833)
