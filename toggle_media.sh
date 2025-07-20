#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="/home/pi/react-carplay/start.sh"
HARUNA_CMD="flatpak run org.kde.haruna /media/pi/DASHCAM"

kill_if_running() {
  pgrep -f "$1" && pkill -f "$1"
}

if pgrep -f react-carplay > /dev/null; then
  # Switch from CarPlay to Haruna
  kill_if_running react-carplay
  sleep 1
  $HARUNA_CMD &
else
  # Switch back to CarPlay
  kill_if_running haruna
  sleep 1
  $CARPLAY_CMD &
fi
