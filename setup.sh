sudo apt-get install libatlas-base-dev
cd && git clone https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard && sudo ./install.sh
sudo apt-get install -y swig libasound2-dev pulseaudio pulseaudio-utils libpulse-dev libpulse-java libpulse0 espeak python3-pygame
sudo pip3 install spidev
sudo pip3 install --upgrade pocketsphinx
sudo pip3 install flask flask-socketio==5.2.0
cd && git clone https://github.com/bjoernkarmann/project_alias.git project_alias && cd project_alias
