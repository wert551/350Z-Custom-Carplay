#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="/home/pi/react-carplay/start.sh"
MEDIA_CMD="celluloid /media/pi/DASHCAM/DCIM"

kill_if_running() {
  pgrep -f "$1" && pkill -f "$1"
}

if pgrep -f react-carplay > /dev/null; then
  # CarPlay is running → switch to media player
  kill_if_running react-carplay
  sleep 1
  $MEDIA_CMD &
else
  # Media player is running → switch back to CarPlay
  kill_if_running celluloid
  sleep 1
  $CARPLAY_CMD &
fi
