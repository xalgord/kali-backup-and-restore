#!/bin/bash

# Check if a zip file is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <backup-zip-file>"
  exit 1
fi

# Define the backup file and extraction directory
ZIP_FILE=$1
EXTRACTION_DIR=~/kali-restore

# Check if the zip file exists
if [ ! -f "$ZIP_FILE" ]; then
  echo "Error: File '$ZIP_FILE' not found!"
  exit 1
fi

# Create extraction directory
mkdir -p $EXTRACTION_DIR

# Extract the zip file
echo "Extracting backup from $ZIP_FILE..."
unzip $ZIP_FILE -d $EXTRACTION_DIR

echo "Restoring Kali Linux settings..."

# 1. Restore Shell Configurations
echo "Restoring shell configurations..."
cp $EXTRACTION_DIR/kali-backup/bashrc ~/.bashrc
cp $EXTRACTION_DIR/kali-backup/zshrc ~/.zshrc

# 2. Restore Installed Packages
echo "Restoring installed packages..."
sudo dpkg --set-selections < $EXTRACTION_DIR/kali-backup/installed-packages.txt
sudo apt-get dselect-upgrade -y

# 3. Restore Network Configurations
echo "Restoring network settings..."
sudo cp $EXTRACTION_DIR/kali-backup/network-interfaces /etc/network/interfaces
nmcli connection import type wifi file $EXTRACTION_DIR/kali-backup/nmcli-settings.txt

# 4. Restore Custom Tools or Binaries
echo "Restoring user-installed binaries..."
sudo cp -r $EXTRACTION_DIR/kali-backup/bin/* /usr/local/bin/
sudo cp -r $EXTRACTION_DIR/kali-backup/go-bin/* /go/bin/

# 5. Restore Desktop Environment Settings (for KDE Plasma, GNOME, or XFCE)
echo "Restoring desktop environment settings..."
cp -r $EXTRACTION_DIR/kali-backup/kde/* ~/.kde/
cp -r $EXTRACTION_DIR/kali-backup/gnome/gnome-settings-backup.conf ~/
dconf load / < ~/gnome-settings-backup.conf
cp -r $EXTRACTION_DIR/kali-backup/xfce/* ~/.config/xfce4/

# 6. Restore Dotfiles
echo "Restoring dotfiles..."
cp $EXTRACTION_DIR/kali-backup/vimrc ~/.vimrc
cp $EXTRACTION_DIR/kali-backup/gitconfig ~/.gitconfig
cp $EXTRACTION_DIR/kali-backup/tmux.conf ~/.tmux.conf

# 7. Restore Custom Services (systemd)
echo "Restoring systemd services..."
sudo cp -r $EXTRACTION_DIR/kali-backup/systemd-services/* /etc/systemd/system/
sudo systemctl daemon-reload

# 8. Restore Cron Jobs
echo "Restoring cron jobs..."
crontab $EXTRACTION_DIR/kali-backup/cronjobs.txt

# 9. Restore Firewall (iptables) Rules
echo "Restoring firewall rules..."
sudo iptables-restore < $EXTRACTION_DIR/kali-backup/iptables-backup.txt

# 10. Restore Aliases
echo "Restoring aliases..."
cat $EXTRACTION_DIR/kali-backup/bash-aliases.txt >> ~/.bashrc
cat $EXTRACTION_DIR/kali-backup/zsh-aliases.txt >> ~/.zshrc

# Clean up extraction directory
echo "Cleaning up..."
rm -rf $EXTRACTION_DIR

echo "Restore complete!"
