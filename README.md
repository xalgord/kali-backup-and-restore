# kali-backup-and-restore
A script to backup and restore shell configurations, installed packages, network settings, binaries, dotfiles, cron jobs, firewall rules, and more.

## kali_backup.sh

### Notes:
You may need to install zip if it's not installed:

```bash
sudo apt-get install zip
```

The script stores temporary files in ~/kali-backup before creating the zip archive and automatically cleans up the folder once the zip file is created.

### Usage

```bash
sudo ./kali_backup.sh
```

## kali_restore.sh

### Important Notes:

- **System Restart**: After restoring some settings (like network configurations or systemd services), a restart might be required for all changes to take effect.
- **Package Reinstallation**: The script uses `dpkg --set-selections` to reselect installed packages. After this, `apt-get dselect-upgrade` is run to reinstall them.

### Usage

```bash
sudo ./kali_restore.sh kali-backup-YYYY-MM-DD.zip
```

## What This Script Does:
- Takes a backup zip file as an argument, extracts it, and restores all backed-up settings.
  
**Restores:**
- Shell configurations (.bashrc, .zshrc)
- Installed packages list and reinstalls them
- Network configurations from /etc/network/interfaces and NetworkManager settings
- Custom binaries and user-installed tools
- Desktop environment settings (for KDE, GNOME, XFCE)
- Dotfiles (.vimrc, .gitconfig, .tmux.conf)
- Custom systemd services
- Cron jobs
- Firewall rules (iptables)
- Custom aliases
