#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

PACKAGES=(
  sway
  waybar
  foot
  wmenu
  rofi
  brightnessctl
  swayosd
  playerctl
  grim
  slurp
  wl-clipboard
  jq
  curl
  mako-notifier
  libnotify-bin
  swayidle
  swaylock
  pavucontrol
  network-manager-gnome
  blueman
  gnome-calendar
  gnome-system-monitor
  power-profiles-daemon
  upower
  fonts-noto-color-emoji
)

echo "Installing packages..."
sudo apt update
sudo apt install -y "${PACKAGES[@]}"

echo "Adding user to video group..."
sudo usermod -aG video "$USER"

echo "Enabling SwayOSD backend..."
sudo systemctl enable --now swayosd-libinput-backend.service || true

echo "Backing up existing config to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

for dir in sway waybar; do
  if [ -e "$HOME/.config/$dir" ]; then
    mv "$HOME/.config/$dir" "$BACKUP_DIR/$dir"
  fi
done

echo "Installing config..."
mkdir -p "$HOME/.config"
cp -a "$REPO_DIR/config/sway" "$HOME/.config/"
cp -a "$REPO_DIR/config/waybar" "$HOME/.config/"
cp -a "$REPO_DIR/config/foot" "$HOME/.config/"

echo "Making scripts executable..."
find "$HOME/.config/sway/scripts" "$HOME/.config/waybar/scripts" -type f -exec chmod +x {} \; 2>/dev/null || true

echo
echo "Done."
echo "Important: log out and log back in so the 'video' group takes effect."
echo "Backup saved at: $BACKUP_DIR"
