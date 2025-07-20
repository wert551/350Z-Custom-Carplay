#!/usr/bin/env bash

export DISPLAY=:0

CARPLAY_CMD="/home/pi/react-carplay/start.sh"
MEDIA_DIR="/media/usb"
VLC_BASE="vlc --fullscreen --qt-start-minimized"

# Decide whether to pass the media folder
if [ -d "$MEDIA_DIR" ] && find "$MEDIA_DIR" -type f | grep -q .; then
  VLC_CMD="$VLC_BASE $MEDIA_DIR"
else
  VLC_CMD="$VLC_BASE"
fi

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
