#!/usr/bin/env python3
from gpiozero import Button
from signal import pause
import subprocess

# GPIO pin 17 = BCM 17 = physical pin 11
button = Button(17, pull_up=True)

def on_press():
    print("[GPIO] Button pressed! Running toggle_media.sh")
    subprocess.call(['/usr/local/bin/toggle_media.sh'])

button.when_pressed = on_press

pause()  # Keep script running
