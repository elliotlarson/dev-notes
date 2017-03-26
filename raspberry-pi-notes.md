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

## GPIO

### Basic Python Blink

I developed this locally and then uploaded to the pi via `scp`.  I called the file `blink.py`

```python
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

GPIO.setup(18, GPIO.OUT)

while True:
    print('LED on')
    GPIO.output(18, GPIO.HIGH)
    time.sleep(1)

    print('LED off')
    GPIO.output(18, GPIO.LOW)
    time.sleep(1)
```

After uploading, I executed it on the pi with:

```bash
$ sudo python3 blink.py # you need to be root to use GPIO
```
