# Termux Native Desktop Setup

## Initial Setup

### Grant Storage Permission

```bash
termux-setup-storage
```

## Installation

### Install Core Packages and Dependencies

Update the system and install essential packages:

```bash
# Core packages
pkg update && pkg upgrade -y
pkg install git curl wget x11-repo tur-repo termux-x11-nightly pulseaudio -y

# Applications
apt install firefox code-oss mousepad eog galculator pinentry-gnome3 helix-grammars -y

# Programming tools
apt install golang rust cargo-binstall nodejs-lts uv -y

# XFCE4 desktop environment and plugins
apt install xfce4 xfce4-whiskermenu-plugin xfce4-clipman-plugin xfce4-screenshooter xfce4-docklike-plugin xfce4-panel-profiles xfce4-taskmanager -y

```

### Setup Startup Script

```bash
cp -r ~/dotfiles/docs/termux/native-desktop-start.sh ~/start.sh
chmod +x start.sh
```

### Launch Desktop Environment

```bash
./start.sh
```

## PRoot Distro Setup

### Install PRoot and Debian

```bash
pkg install proot-distro
pd install debian
```

### Symlink Developer Folder

```bash
ln -s /data/data/com.termux/files/usr/var/lib/proot-distro/containers/debian/rootfs/home/gouranga/Developer ~/Developer
```

## Customization

### Update Termux Homepage

Edit the MOTD (Message of the Day) file:

```bash
nano $PREFIX/etc/motd
```

### Configure GPG Agent

Edit the GPG configuration:

```bash
nano ~/.gnupg/gpg-agent.conf
```

Add the following line:

```bash
pinentry-program /data/data/com.termux/files/usr/bin/pinentry-gnome3
```

## Keyboard Shortcuts

| Function             | Command                   | Shortcut      |
| -------------------- | ------------------------- | ------------- |
| Application Launcher | `rofi -show drun`         | `Ctrl+Space`  |
| Clipboard Manager    | `xfce4-clipman-history`   | `Super+Alt+V` |
| Main Menu            | `xfce4-popup-whiskermenu` | `Super`       |
