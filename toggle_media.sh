#!/usr/bin/env bash

export DISPLAY=:0
DASHCAM_PATH="/media/pi/DASHCAM/DCIM"
CARPLAY_CMD="/home/pi/react-carplay/start.sh"

if [ -d "$DASHCAM_PATH" ]; then
  HARUNA_CMD="flatpak run org.kde.haruna \"$DASHCAM_PATH\""
else
  HARUNA_CMD="flatpak run org.kde.haruna --fullscreen"
fi

kill_if_running() {
  pgrep -f "$1" && pkill -f "$1"
}

if pgrep -f react-carplay > /dev/null; then
  kill_if_running react-carplay
  sleep 1
  eval $HARUNA_CMD &
else
  kill_if_running haruna
  sleep 1
  $CARPLAY_CMD &
fi
