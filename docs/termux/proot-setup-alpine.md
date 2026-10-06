# Alpine Linux on proot-distro

Quick setup guide for running Alpine Linux inside proot (on Termux) with a regular sudo user.

## 1. Install proot-distro and Alpine

Run in your host shell (Termux):

```bash
apt update -y && apt upgrade -y
apt install proot-distro
proot-distro install alpine
```

## 2. Log in as root

```bash
proot-distro login alpine
```

## 3. Install sudo and bash

Alpine ships with `ash` by default, so install `bash` along with `sudo`:

```bash
apk update
apk add sudo bash
```

## 4. Create a user

Replace `yourusername` with your own name:

```bash
adduser -s /bin/bash yourusername
```

You will be prompted to set and confirm a password. Other fields can be skipped by pressing `Enter`.

## 5. Give the user sudo access

Add the user to the `wheel` group and enable sudo for that group:

```bash
addgroup yourusername wheel
echo '%wheel ALL=(ALL:ALL) ALL' >> /etc/sudoers
```

## 6. Log in as your user

Exit the root session (`exit`), then from the host shell:

```bash
proot-distro login alpine --user yourusername
```

Test sudo:

```bash
sudo whoami   # should print: root
```

## Notes

- Run `sudo apk update && sudo apk upgrade` occasionally to keep packages up to date.
- Alpine uses `apk` instead of `apt`/`dnf`/`pacman`, and `musl` instead of `glibc`, so some prebuilt binaries may not run.
- This is the user dir you can access from host shell (Termux): `$PREFIX/var/lib/proot-distro/containers/alpine/rootfs/home/yourusername`
