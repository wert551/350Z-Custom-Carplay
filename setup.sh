#!/usr/bin/env bash
# setup.sh — install deps, deploy scripts, enable services

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (e.g. sudo ./setup.sh)"
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="/home/${SUDO_USER:-pi}"

echo "Installing packages…"
apt update
apt install -y kodi python3-rpi.gpio xbindkeys

echo "Deploying toggle_media.sh…"
install -m 755 "$REPO_DIR/toggle_media.sh" /usr/local/bin/toggle_media.sh

echo "Deploying gpio_toggle.py…"
install -m 755 "$REPO_DIR/gpio_toggle.py" /usr/local/bin/gpio_toggle.py

echo "Deploying systemd service…"
install -m 644 "$REPO_DIR/gpio-toggle.service" /etc/systemd/system/gpio-toggle.service

echo "Reloading systemd and enabling service…"
systemctl daemon-reload
systemctl enable gpio-toggle
systemctl start gpio-toggle

echo "Setting up xbindkeys…"
# Copy xbindkeysrc for the real user
cp "$REPO_DIR/xbindkeysrc" "$USER_HOME/.xbindkeysrc"
chown "${SUDO_USER:-pi}:${SUDO_USER:-pi}" "$USER_HOME/.xbindkeysrc"

# Add xbindkeys to LX autostart if not already present
AUTOSTART_DIR="$USER_HOME/.config/lxsession/LXDE-pi"
AUTOSTART_FILE="$AUTOSTART_DIR/autostart"
mkdir -p "$AUTOSTART_DIR"
grep -qxF "@xbindkeys" "$AUTOSTART_FILE" 2>/dev/null || echo "@xbindkeys" >> "$AUTOSTART_FILE"
chown -R "${SUDO_USER:-pi}:${SUDO_USER:-pi}" "$AUTOSTART_DIR"

echo "Enabling xbindkeys in current session…"
# Launch it now if not already running
if ! pgrep -x xbindkeys >/dev/null; then
  sudo -u "${SUDO_USER:-pi}" DISPLAY=":0" xbindkeys
fi

echo "All done! Reboot to test. React-CarPlay will launch on boot, and GPIO17 or Right-Alt + S will toggle Kodi."
