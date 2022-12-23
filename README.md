# alias
This README contains the latest documentation to setup Project Alias on a Raspberry Pi A+.

## Pi HAT

If you choose to not modify the shell for using a plug-in power supply cable, you can skip on to the next section. However, if you're hard wiring the power source onto the GPIO header pins of your Pi HAT, then you'll need this [schematic](https://wiki.seeedstudio.com/ReSpeaker_2_Mics_Pi_HAT/#schematic-online-viewer). The schematic will show you the role of each pin on the header. The top left most pins are where you'll need to focus. On the first row, the first pin will supply power to the Pi HAT, so solder your hot wire there. Skip two pins to the right that will be the pin you solder your ground wire to.

## Configuring Your Pi To Use Alias

### SD Card & Pi OS

1. Download and install Raspberry Pi Imager on your computer. You can find the latest version of Raspberry Pi Imager on the official Raspberry Pi website (https://www.raspberrypi.org/downloads/).
2. Insert your micro SD card into your computer's SD card reader or use a micro SD to SD card adapter.
3. Launch Raspberry Pi Imager and select the "CHOOSE OS" tab.
4. For the sake of simplicity we'll install the recommended 32bit OS (with a GUI Desktop)
5. Select the "CHOOSE STORAGE" tab and choose your micro SD card from the drop-down list.
6. Click the "WRITE" button to begin the installation process. This may take a few minutes to complete.
7. Once the installation is finished, remove it from your computer and plug it into your Pi device (the card is automatically ejected and can be removed from your device)

### Setting up Alias

We'll now need to prep the OS to run Alias. First we should install any pending upgrades that the OS requires and reboot.

#### Hardware dependencies

```sh
sudo apt-get update && sudo apt-get upgrade
sudo reboot now
```

The dependencies of alias require Python3 and Git to be installed. Luckily the recommended Raspberry Pi OS comes pre-packaged with both. So all we have to do is install the remaining dependency to continue.

```sh
sudo apt-get install libatlas-base-dev
```

Next we need to install the sound driver for the ResSpeaker Hat.

```sh
cd && git clone https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard && sudo ./install.sh
```

After the sound driver is installed, we must tell the Pi to disable the default sound card. That can be done by following this [guide](https://www.instructables.com/Disable-the-Built-in-Sound-Card-of-Raspberry-Pi/).

#### Software dependencies

Let's now install pocketsphinx, which is used for voice recognition, and its dependencies. Most of the dependencies will already be present, so we're mainly running this for the sake of sanity.

```sh
sudo pip3 install spidev
sudo apt-get install -y swig libasound2-dev pulseaudio pulseaudio-utils libpulse-dev libpulse-java libpulse0
sudo pip3 install --upgrade pocketsphinx
```

Installing espeak is next, which handles text-to-speach.

```sh
sudo apt-get install espeak
```

We must install flask and a socketio library for it.

```sh
sudo pip3 install flask flask-socketio==5.2.0
```

Lastly we need to install pygame

```sh
sudo apt-get install python3-pygame
```

It's required to install a private network for alias to run on. That can be done by following this [guide](https://raspberrypi-guide.github.io/networking/create-wireless-access-point)

Finally we can install Project Alias itself

```sh
cd && git clone https://github.com/bjoernkarmann/project_alias.git project_alias && cd project_alias
```

Now that Project Alias is installed, we need to change a few things before telling `systemd` how to run it. The following file adds some necessary environment variables for the sound device to be found in addition to cleaning up how and where the app is run. Simply replace `project_alias/alias.service` with the following (replacing `{your-user}` with your linux username):

```sh
[Unit]
Description=Project Alias
After=network.target
Requires=network.target

[Service]
Type=idle
Environment="XDG_RUNTIME_DIR=/run/user/1000"
Environment="PULSE_RUNTIME_PATH=/run/user/1000/pulse/"
ExecStartPre=/usr/bin/python3 -u sleep.py
ExecStart=/usr/bin/python3 -u app.py
WorkingDirectory=/home/{your-user}/project_alias
StandardOutput=append:/home/{your-user}/alias-output.log
StandardError=append:/home/{your-user}/alias-errors.log
Restart=always
RestartSec=0
User=pi

[Install]
WantedBy=multi-user.target
```

This application needs to run unconditionally, at all times, in order to achieve the goal of blocking our device's microphones. To do that we have to configure `systemd` to run alias in the background and turn it on when the system reboots.

```sh
sudo cp alias.service /etc/systemd/system/alias.service
sudo chmod 644 /etc/systemd/system/alias.service
systemctl enable alias
```

### Socket.io

```html
<script src="https://cdn.socket.io/4.5.4/socket.io.min.js" integrity="sha384-/KNQL8Nu5gCHLqwqfQjA689Hhoqgi2S84SNUxC3roTe4EhJ9AfLkp8QiQcU8AMzI" crossorigin="anonymous"></script>
```
