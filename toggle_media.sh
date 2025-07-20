#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="/home/pi/react-carplay/start.sh"
DASHCAM_PATH="/media/pi/DASHCAM/DCIM"

# Use actual process name for Haruna (detectable by this string)
MEDIA_PROCESS="haruna"

if [ -d "$DASHCAM_PATH" ]; then
  MEDIA_CMD="haruna \"$DASHCAM_PATH\""
else
  MEDIA_CMD="haruna"
fi

kill_if_running() {
  local process_name="$1"
  pgrep -f "$process_name" && pkill -f "$process_name"
}

if pgrep -f react-carplay > /dev/null; then
  # CarPlay is running → switch to Haruna
  kill_if_running react-carplay
  sleep 1
  eval $MEDIA_CMD &
elif pgrep -f "$MEDIA_PROCESS" > /dev/null; then
  # Haruna is running → switch to CarPlay
  kill_if_running "$MEDIA_PROCESS"
  sleep 1
  $CARPLAY_CMD &
else
  # Nothing running, fallback to CarPlay
  $CARPLAY_CMD &
fi
