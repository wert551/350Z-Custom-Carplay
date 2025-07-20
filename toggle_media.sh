#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="$HOME/Desktop/Carplay.AppImage"
DASHCAM_PATH="/media/pi/DASHCAM/DCIM"
INTRO_PATH="$HOME/350Z-Custom-Carplay/Carplay_intro"

play_intro() {
  if [ -d "$INTRO_PATH" ]; then
    mpv --loop=no --fs --image-display-duration=0.033 --no-audio "$INTRO_PATH"/frame_0*.png
  fi
}

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
  play_intro
  "${MEDIA_CMD[@]}" &
elif is_haruna_running; then
  log "Haruna running → switching to CarPlay"
  pkill -f haruna
  sleep 1
  play_intro
  DISPLAY=:0 "$CARPLAY_CMD" &
else
  log "Neither running → launching CarPlay"
  play_intro
  DISPLAY=:0 "$CARPLAY_CMD" &
fi
