#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="/home/pi/react-carplay/start.sh"
MEDIA_DIR="/media/usb"  # update this if your dashcam mounts elsewhere
VLC_CMD="vlc --fullscreen --qt-start-minimized $MEDIA_DIR"

kill_if_running() {
  pgrep -f "$1" && pkill -f "$1"
}

if pgrep -f react-carplay > /dev/null; then
  kill_if_running react-carplay
  sleep 1
  $VLC_CMD &
else
  kill_if_running vlc
  sleep 1
  $CARPLAY_CMD &
fi
