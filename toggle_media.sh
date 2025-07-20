#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="/home/pi/Desktop/Carplay.AppImage"
DASHCAM_PATH="/media/pi/DASHCAM/DCIM"

if [ -d "$DASHCAM_PATH" ]; then
  MEDIA_CMD=("haruna" "$DASHCAM_PATH")
else
  MEDIA_CMD=("haruna")
fi

is_carplay_running() {
  pgrep -f react-carplay > /dev/null
}

is_haruna_running() {
  pgrep -f haruna > /dev/null
}

log() {
  echo "[TOGGLE] $1" | systemd-cat -t carplay-toggle
}

if is_carplay_running; then
  log "CarPlay running → switching to Haruna"
  pkill -f react-carplay
  sleep 1
  "${MEDIA_CMD[@]}" &
elif is_haruna_running; then
  log "Haruna running → switching to CarPlay"
  pkill -f haruna
  sleep 1
  DISPLAY=:0 /home/pi/react-carplay/start.sh &
else
  log "Neither running → launching CarPlay"
  DISPLAY=:0 /home/pi/react-carplay/start.sh &
fi
