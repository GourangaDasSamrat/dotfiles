# Arch Linux ARM on proot-distro

Quick setup guide for running Arch Linux ARM inside proot (on Termux) with a regular sudo user.

## 1. Install proot-distro and Arch Linux ARM

Run in your host shell (Termux):

```bash
apt update -y && apt upgrade -y
apt install proot-distro
proot-distro install danhunsaker/archlinuxarm:latest
```

## 2. Log in as root

```bash
proot-distro login archlinuxarm
```

## 3. Disable pacman sandbox

The sandbox does not work under proot, so turn it off.

Open the config file:

```bash
nano /etc/pacman.conf
```

Scroll to the `[options]` section and add this line exactly as written:

```ini
DisableSandbox
```

Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).

## 4. Install sudo and nano

```bash
pacman -Sy sudo nano --noconfirm
```

## 5. Create a user

Replace `yourusername` with your own name:

```bash
useradd -m -g users -G wheel -s /bin/bash yourusername
passwd yourusername
```

## 6. Give the wheel group sudo access

```bash
EDITOR=nano visudo
```

Find and uncomment this line (remove the leading `#`):

```
%wheel ALL=(ALL:ALL) ALL
```

Save and exit.

## 7. Log in as your user

Exit the root session (`exit`), then from the host shell:

```bash
proot-distro login archlinuxarm --user yourusername
```

Test sudo:

```bash
sudo whoami   # should print: root
```

## Notes

- Run `pacman -Syu` occasionally to keep the system up to date.
- If `sudo` complains about the sandbox or pacman fails to download, double-check that `DisableSandbox` is inside `[options]` in `/etc/pacman.conf`.
- This is the user dir you can access from host shell (Termux): `$PREFIX/var/lib/proot-distro/containers/archlinuxarm/rootfs/home/yourusername`
