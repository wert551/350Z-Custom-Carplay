#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="/home/pi/react-carplay/start.sh"

DASHCAM_DIR="/media/pi/DASHCAM/DCIM"

if [ -d "$DASHCAM_DIR" ]; then
  MEDIA_CMD="celluloid \"$DASHCAM_DIR\""
else
  MEDIA_CMD="celluloid --fullscreen"
fi

kill_if_running() {
  pgrep -f "$1" && pkill -f "$1"
}

if pgrep -f react-carplay > /dev/null; then
  # CarPlay is running → switch to media player
  kill_if_running react-carplay
  sleep 1
  eval $MEDIA_CMD &
else
  # Media player is running or nothing → switch to CarPlay
  kill_if_running celluloid
  sleep 1
  $CARPLAY_CMD &
fi
