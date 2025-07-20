#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="/home/pi/react-carplay/start.sh"
KODI_CMD="kodi --fs"

kill_if_running() {
  pgrep -f "$1" && pkill -f "$1"
}

if pgrep -f react-carplay > /dev/null; then
  # CarPlay is running → switch to Kodi
  kill_if_running react-carplay
  sleep 1
  $KODI_CMD &
else
  # Kodi is running or nothing → switch to CarPlay
  kill_if_running kodi
  sleep 1
  $CARPLAY_CMD &
fi
