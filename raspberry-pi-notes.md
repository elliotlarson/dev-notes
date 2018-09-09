# Raspberry PI Notes

## Setup Raspian

I setup my PI with the **Pixel Jessie** version of Raspian. [Download the image here](https://www.raspberrypi.org/downloads/raspbian/).

I inserted my SD card into my Mac and used [Etcher](https://etcher.io/) to flash it with the Jessie image.

After Etcher is finished, you can **enable SSH access** by putting an empty file named `ssh` in the root directory of the boot disk.

Then I plugged it into the network via the ethernet cable in order to **setup the WIFI**.  I scanned the network and located the raspberry pi's IP address, ssh-ed in, and setup the WIFI with:

```bash
$ ssh pi@192.168.1.141
$ sudo su # need to be root for the following
$ wpa_passphrase "networkname" "password" >> /etc/wpa_supplicant/wpa_supplicant.conf
```

After disconnecting the pi from the ethernet and restarting, the pi showed up on the network via its WIFI connection.

## Configure keyboard

The default keyboard setup is for the UK locality.  You might need to change your keyboard configuration up if you type and get strange characters for some of the keys:

```bash
$ sudo dpkg-reconfigure keyboard-configuration
```

Options I've picked in the past
* Keyboard model: Generic 101-key PC
* Keyboard layout: English (US)
* Key to function as AltGr: Both Alt keys
* Compose key: Menu key

```bash
# reboot for settings to take effect
$ sudo reboot
```

### Swapping the ctrl and caps lock keys

```bash
$ sudo vim /etc/default/keyboard
```

Make sure the `XKBOPTIONS` entry includes `ctrl:nocaps`.  Mine looks like:

```txt
XKBOPTIONS="lv3:alt_switch,compose:menu,ctrl:nocaps"
```

After this, re-run the `dpkg-reconfigure` command and hit enter for everything including the final question about keeping current keyboard configurations; then reboot.

```bash
$ sudo dpkg-reconfigure keyboard-configuration
# hit enter a few times
$ sudo reboot
```

## What version of OS is this

```bash
$ cat /etc/os-release
```

## Wireless

See the current wifi config:

```bash
$ iwconfig
```

... or, just get the ID of the network:

```bash
$ iwgetid
```

See what wireless networks are available:

```bash
$ sudo iwlist wlan0 scan | less
# then search for the network you want
```

```bash
$ wpa_passphrase "networkname" "password" >> /etc/wpa_supplicant/wpa_supplicant.conf
```

## GPIO

### Basic LED Blink with Python3

Hardware setup:

1. Connect wire from ground pin on raspberry pi to ground row on breadboard
1. Connect 220 resistor from ground row to breadboard row
1. Add short leg of led to ground resistor row of breadboard
1. Connect Pin 23 from Raspberry pi to breadboard row
1. Connect long leg of led to RP 23 breadboard row

See img `img/raspberry-pi-notes/led_blink.png`.

Software setup:

I developed this locally and then uploaded to the pi via `scp`.

I called the file `led_blink.py`

```python
from gpiozero import LED
import time

led = LED(23)

while True:
    led.on()
    time.sleep(1)
    led.off()
    time.sleep(1)
```
After uploading, I executed it on the pi with:

```bash
$ python3 led_blink.py # you need to be root to use GPIO
```

### Control brightness of LED

This involves using pulse width modulation to change the frequency of showing the light, giving the impression of a dimmer than 100% brightness.  The pulse happens so fast it is indistinguishable to the naked eye.

```python
import RPi.GPIO as GPIO

led_pin = 23
GPIO.setmode(GPIO.BCM)
GPIO.setup(led_pin, GPIO.OUT)

pwm_led = GPIO.PWM(led_pin, 500)
pwm_led.start(100)

while True:
    duty_s = input("Enter brightness (1-100)?: ")
    duty = int(duty_s)
    pwm_led.ChangeDutyCycle(duty)

```

### Fade in and out

```python
import RPi.GPIO as GPIO
import time

GPIO.setwarnings(False)

led_pin = 23
GPIO.setmode(GPIO.BCM)
GPIO.setup(led_pin, GPIO.OUT)

pwm_led = GPIO.PWM(led_pin, 500)
current_brightness = 1
pwm_led.start(current_brightness)

FADE_DELAY = .01

def set_brightness(brightness):
    pwm_led.ChangeDutyCycle(brightness)

def fade_up_to(target_brightness):
    global current_brightness
    while current_brightness < target_brightness:
        current_brightness += 1
        set_brightness(current_brightness)
        time.sleep(FADE_DELAY)

def fade_down_to(target_brightness):
    global current_brightness
    while current_brightness > target_brightness:
        current_brightness -= 1
        set_brightness(current_brightness)
        time.sleep(FADE_DELAY)

def fade_to(target_brightness):
    if target_brightness > current_brightness:
        fade_up_to(target_brightness)
    else:
        fade_down_to(target_brightness)

while True:
    target_brightness = input("Enter brightness (1-100)?: ")
    fade_to(int(target_brightness))
```

### Creating a web UI

Using the Flask python framework, we'll create a simple server:

Install Flask for python 3.

```bash
# create project directory
$ mkdir my_project && cd my_project
# use venv
$ python3 -m venv venv
# activate the environment
$ . venv/bin/activate
# install Flask
$ pip install Flask
```
