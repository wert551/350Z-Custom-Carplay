#!/usr/bin/env bash
# toggle_media.sh: swap between React-CarPlay and Kodi
CARPLAY_CMD="DISPLAY=:0 /home/pi/react-carplay/start.sh"
KODI_CMD="DISPLAY=:0 kodi-standalone --fs"

kill_if_running() {
  pgrep -f "$1" && pkill -f "$1"
}

if pgrep -f react-carplay > /dev/null; then
  # In CarPlay → switch to Kodi
  kill_if_running react-carplay
  sleep 1
  $KODI_CMD &
else
  # Otherwise → switch to CarPlay
  kill_if_running kodi-standalone
  sleep 1
  $CARPLAY_CMD &
fi
