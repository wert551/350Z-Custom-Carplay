#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="$HOME/Desktop/Carplay.AppImage"
DASHCAM_PATH="/media/pi/DASHCAM/DCIM"
INTRO_PATH="$HOME/350Z-Custom-Carplay/Carplay_intro"

play_intro_and_wait_for() {
  local target_process="$1"
  local kill_process
  local last_frame="$INTRO_PATH/frame_0099.png"

  if [ "$target_process" == "haruna" ]; then
    kill_process="react-carplay"
  else
    kill_process="haruna"
  fi

  if [ -d "$INTRO_PATH" ]; then
    log "Launching splash..."
    mpv --loop=no --fs --image-display-duration=0.033 --no-audio "$INTRO_PATH"/frame_0*.png &
    local splash_pid=$!

    # Allow MPV time to appear
    sleep 1

    log "Killing $kill_process..."
    pkill -f "$kill_process"

    log "Launching $target_process..."
    if [ "$target_process" == "haruna" ]; then
      "${MEDIA_CMD[@]}" &
    else
      DISPLAY=:0 "$CARPLAY_CMD" &
    fi

    # Wait for the splash animation to complete
    wait $splash_pid

    # If new app hasn't started yet, show the last frame until it does
    until pgrep -f "$target_process" > /dev/null; do
      log "Waiting for $target_process to start..."
      mpv --fs --no-audio --image-display-duration=9999 --loop-file=no "$last_frame"
      sleep 0.5
    done

    log "$target_process started. Transition complete."
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
