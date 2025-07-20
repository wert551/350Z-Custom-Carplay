#!/usr/bin/env python3
from gpiozero import Button
from signal import pause
import subprocess

def on_press():
    print("[GPIO] Button pressed! Running toggle_media.sh")
    subprocess.call(['/usr/local/bin/toggle_media.sh'])

button = Button(17, pull_up=True)
button.when_pressed = on_press

pause()
