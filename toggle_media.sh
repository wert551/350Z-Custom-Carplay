#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="/home/pi/react-carplay/start.sh"
DASHCAM_PATH="/media/pi/DASHCAM/DCIM"

if [ -d "$DASHCAM_PATH" ]; then
  MEDIA_CMD="haruna \"$DASHCAM_PATH\""
else
  MEDIA_CMD="haruna"
fi

kill_if_running() {
  pgrep -f "$1" && pkill -f "$1"
}

if pgrep -f react-carplay > /dev/null; then
  kill_if_running react-carplay
  sleep 1
  eval $MEDIA_CMD &
else
  kill_if_running haruna
  sleep 1
  $CARPLAY_CMD &
fi
