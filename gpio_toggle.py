#!/usr/bin/env python3
import RPi.GPIO as GPIO
import subprocess, time

PIN = 17
GPIO.setmode(GPIO.BCM)
GPIO.setup(PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

def cb(channel):
    subprocess.call(['/usr/local/bin/toggle_media.sh'])

GPIO.add_event_detect(PIN, GPIO.FALLING, callback=cb, bouncetime=200)

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    GPIO.cleanup()
