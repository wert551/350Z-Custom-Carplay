#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="$HOME/Desktop/Carplay.AppImage"
DASHCAM_PATH="/media/pi/DASHCAM/DCIM"
INTRO_PATH="$HOME/350Z-Custom-Carplay/Carplay_intro"

play_intro_and_wait_for() {
  local target_process="$1"
  local last_frame="$INTRO_PATH/frame_0099.png"

  if [ -d "$INTRO_PATH" ]; then
    # 1. Start animation in background
    mpv --loop=no --fs --image-display-duration=0.033 --no-audio "$INTRO_PATH"/frame_0*.png &

    # 2. Kill current app and launch next in parallel
    if [ "$target_process" == "haruna" ]; then
      pkill -f react-carplay
      "${MEDIA_CMD[@]}" &
    else
      pkill -f haruna
      DISPLAY=:0 "$CARPLAY_CMD" &
    fi

    # 3. Wait for animation to finish
    wait

    # 4. Hold on last frame until new app is running
    until pgrep -f "$target_process" > /dev/null; do
      mpv --fs --no-audio --image-display-duration=9999 --loop-file=no "$last_frame"
      sleep 0.5
    done
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
  play_intro_and_wait_for "haruna"
elif is_haruna_running; then
  log "Haruna running → switching to CarPlay"
  play_intro_and_wait_for "react-carplay"
else
  log "Neither running → launching CarPlay"
  play_intro_and_wait_for "react-carplay"
fi
