# PRoot Debian Setup

## Initial System Configuration

### Update System Packages

```bash
apt update && apt upgrade -y
```

### Install Essential Utilities

```bash
apt install sudo adduser -y
```

### Create User Account

Create a user named `gouranga`:

```bash
adduser gouranga
```

### Configure Sudo Permissions

Edit the sudoers file:

```bash
nano /etc/sudoers
```

Add the following line to grant `gouranga` full sudo access:

```bash
gouranga ALL=(ALL:ALL) ALL
```

## User Setup

### Switch to Regular User

You can now use the system as the regular `gouranga` user.

### Install Development Tools

```bash
sudo apt install git curl wget -y
```

## System Customization

### Configure Timezone

Set the timezone to Asia/Dhaka:

```bash
sudo ln -sf /usr/share/zoneinfo/Asia/Dhaka /etc/localtime
echo "Asia/Dhaka" | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata
```
