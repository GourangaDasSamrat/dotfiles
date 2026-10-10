---
title: Ubuntu on proot-distro
---

Quick setup guide for running Ubuntu inside proot (on Termux) with a regular sudo user.

## 1. Install proot-distro and Ubuntu

Run in your host shell (Termux):

```bash
apt update -y && apt upgrade -y
apt install proot-distro
proot-distro install ubuntu
```

## 2. Log in as root

```bash
proot-distro login ubuntu
```

## 3. Install sudo and adduser

```bash
apt update && apt install sudo adduser -y
```

## 4. Create a user

Replace `yourusername` with your own name:

```bash
adduser yourusername
```

You will be prompted to set and confirm a password, followed by some optional fields (full name, room number, etc.). Press `Enter` to skip those.

## 5. Give the user sudo access

```bash
usermod -aG sudo yourusername
```

## 6. Log in as your user

Exit the root session (`exit`), then from the host shell:

```bash
proot-distro login ubuntu --user yourusername
```

Test sudo:

```bash
sudo whoami   # should print: root
```

## Notes

- Run `sudo apt update && sudo apt upgrade -y` occasionally to keep packages up to date.
- This is the user dir you can access from host shell (Termux): `$PREFIX/var/lib/proot-distro/containers/ubuntu/rootfs/home/yourusername`
