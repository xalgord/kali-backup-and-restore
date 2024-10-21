#!/bin/bash

# Define backup directory and file name
BACKUP_DIR=~/kali-backup
ZIP_FILE=kali-backup-$(date +%Y-%m-%d).zip

# Create backup directory
mkdir -p $BACKUP_DIR

echo "Starting Kali Linux backup..."

# 1. Backup Shell Configurations
echo "Backing up shell configurations..."
cp ~/.bashrc $BACKUP_DIR/bashrc
cp ~/.zshrc $BACKUP_DIR/zshrc

# 2. Backup Installed Packages
echo "Backing up installed packages list..."
dpkg --get-selections > $BACKUP_DIR/installed-packages.txt

# 3. Backup Network Configurations
echo "Backing up network settings..."
sudo cp /etc/network/interfaces $BACKUP_DIR/network-interfaces
nmcli connection export uuid > $BACKUP_DIR/nmcli-settings.txt

# 4. Backup Custom Tools or Binaries
echo "Backing up user-installed binaries..."
mkdir -p $BACKUP_DIR/bin/
sudo cp -r /usr/local/bin/* $BACKUP_DIR/bin/
mkdir -p $BACKUP_DIR/go-bin/
sudo cp -r /go/bin/* $BACKUP_DIR/go-bin/

# 5. Backup Desktop Environment Settings (for KDE Plasma, GNOME, or XFCE)
echo "Backing up desktop environment settings..."
mkdir -p $BACKUP_DIR/kde $BACKUP_DIR/xfce $BACKUP_DIR/gnome
cp -r ~/.config/plasma* $BACKUP_DIR/kde/
cp -r ~/.kde $BACKUP_DIR/kde/
dconf dump / > $BACKUP_DIR/gnome/gnome-settings-backup.conf
cp -r ~/.config/xfce4/ $BACKUP_DIR/xfce/

# 6. Backup Dotfiles
echo "Backing up dotfiles..."
cp ~/.vimrc $BACKUP_DIR/vimrc
cp ~/.gitconfig $BACKUP_DIR/gitconfig
cp ~/.tmux.conf $BACKUP_DIR/tmux.conf

# 7. Backup Custom Services (systemd)
echo "Backing up systemd services..."
mkdir -p $BACKUP_DIR/systemd-services/
sudo cp -r /etc/systemd/system/* $BACKUP_DIR/systemd-services/

# 8. Backup Cron Jobs
echo "Backing up cron jobs..."
crontab -l > $BACKUP_DIR/cronjobs.txt

# 9. Backup Firewall (iptables) Rules
echo "Backing up firewall rules..."
sudo iptables-save > $BACKUP_DIR/iptables-backup.txt

# 10. Backup Aliases
echo "Backing up aliases..."
grep '^alias' ~/.bashrc > $BACKUP_DIR/bash-aliases.txt
grep '^alias' ~/.zshrc > $BACKUP_DIR/zsh-aliases.txt

# 11. Create zip file of the backup
echo "Creating zip file..."
cd ~
zip -r $ZIP_FILE kali-backup

# Clean up backup directory
echo "Cleaning up..."
rm -rf $BACKUP_DIR

echo "Backup complete. Backup file: $ZIP_FILE"
