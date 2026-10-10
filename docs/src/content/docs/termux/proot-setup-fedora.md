---
title: Fedora on proot-distro
---

Quick setup guide for running Fedora inside proot (on Termux) with a regular sudo user.

## 1. Install proot-distro and Fedora

Run in your host shell (Termux):

```bash
apt update -y && apt upgrade -y
apt install proot-distro
proot-distro install fedora
```

## 2. Log in as root

```bash
proot-distro login fedora
```

## 3. Update packages

```bash
dnf update -y
```

## 4. Create a user

Replace `yourusername` with your own name:

```bash
useradd -m -G wheel yourusername
```

## 5. Fix sudo permission

The `sudo` binary needs the SUID bit set to work under proot:

```bash
chmod 4755 /usr/bin/sudo
```

## 6. Set a password

```bash
passwd yourusername
```

You will be prompted to enter and confirm the new password.

## 7. Log in as your user

Exit the root session (`exit`), then from the host shell:

```bash
proot-distro login fedora --user yourusername
```

Test sudo:

```bash
sudo whoami   # should print: root
```

## Notes

- Run `sudo dnf update -y` occasionally to keep packages up to date.
- Members of the `wheel` group get sudo access by default on Fedora, so no `visudo` edit is needed.
- If `sudo` complains about permissions, double-check that `chmod 4755 /usr/bin/sudo` was run as root.
- This is the user dir you can access from host shell (Termux): `$PREFIX/var/lib/proot-distro/containers/fedora/rootfs/home/yourusername`
