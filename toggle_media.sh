#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="/home/pi/react-carplay/start.sh"
DASHCAM_PATH="/media/pi/DASHCAM/DCIM"

# Determine whether dashcam folder is available
if [ -d "$DASHCAM_PATH" ]; then
  MEDIA_CMD=("haruna" "$DASHCAM_PATH")
else
  MEDIA_CMD=("haruna")
fi

# Detect running processes
is_carplay_running() {
  pgrep -f react-carplay > /dev/null
}

is_haruna_running() {
  pgrep -f haruna > /dev/null
}

# Toggle logic
if is_carplay_running; then
  echo "[TOGGLE] CarPlay running → switching to Haruna"
  pkill -f react-carplay
  sleep 1
  "${MEDIA_CMD[@]}" &
elif is_haruna_running; then
  echo "[TOGGLE] Haruna running → switching to CarPlay"
  pkill -f haruna
  sleep 1
  bash -c "$CARPLAY_CMD" &
else
  echo "[TOGGLE] Neither running → launching CarPlay"
  bash -c "$CARPLAY_CMD" &
fi
