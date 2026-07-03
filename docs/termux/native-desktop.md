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
pkg update && pkg upgrade -y
pkg install git curl wget x11-repo -y
pkg install tur-repo termux-x11-nightly pulseaudio -y

apt install firefox code-oss mousepad eog galculator pinentry-gnome3 helix-grammars -y
apt install golang rust cargo-binstall nodejs-lts uv -y
apt install xfce4 xfce4-whiskermenu-plugin xfce4-clipman-plugin xfce4-screenshooter xfce4-docklike-plugin xfce4-panel-profiles xfce4-taskmanager -y
```

### Setup Startup Script

```bash
ln -s ~/dotfiles/docs/termux/native-desktop-start.sh ~/start.sh
```

### Install Desktop Themes and Icons

```bash
mkdir -p ~/.themes && cd ~/.themes
wget https://github.com/vinceliuice/MacTahoe-gtk-theme/raw/refs/heads/main/release/MacTahoe-Dark.tar.xz
tar -xf MacTahoe-Dark.tar.xz
rm -rf MacTahoe-Dark.tar.xz

git clone https://github.com/vinceliuice/MacTahoe-icon-theme
cd MacTahoe-icon-theme
./install.sh -t default -d ~/.icons
rm -rf ../MacTahoe-icon-theme

mkdir -p ~/.local/share/xfce4/terminal/colorschemes
cd ~/.local/share/xfce4/terminal/colorschemes
wget https://github.com/dracula/xfce4-terminal/raw/refs/heads/master/Dracula.theme

mkdir -p ~/.local/share/gtksourceview-4/styles
cd ~/.local/share/gtksourceview-4/styles
wget https://github.com/dracula/mousepad/raw/refs/heads/master/dracula.xml
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
ln -s $PREFIX/var/lib/proot-distro/containers/debian/rootfs/home/gouranga/Developer ~/Developer
```

## Customization

### Install Termux Theme

```bash
cd ~/.termux
wget https://github.com/adi1090x/termux-style/raw/refs/heads/master/colors/dracula.properties
mv dracula.properties colors.properties
```

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
pinentry-program $PREFIX/bin/pinentry-gnome3
```

## Keyboard Shortcuts

| Function             | Command                   | Shortcut      |
| -------------------- | ------------------------- | ------------- |
| Application Launcher | `rofi -show drun`         | `Ctrl+Space`  |
| Clipboard Manager    | `xfce4-clipman-history`   | `Super+Alt+V` |
| Main Menu            | `xfce4-popup-whiskermenu` | `Super`       |
