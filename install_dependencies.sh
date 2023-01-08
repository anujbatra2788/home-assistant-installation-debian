cd /tmp

echo "Updating apt"
sudo apt -y update
sudo apt -y upgrade

echo "Installing python"

sudo apt install -y vim \
	dkms \
	linux-headers-$(uname -r) \
	build-essential \
	apparmor \
	jq \
	wget \
	curl \
	udisks2 \
	libglib2.0-bin \
	network-manager \
	dbus \
	lsb-release \
	systemd-journal-remote \
	libssl-dev \
	git \
	zlib1g-dev \
	libncurses5-dev \
	libgdbm-dev \
	libnss3-dev \
	libreadline-dev \
	libffi-dev \
	libsqlite3-dev \
	libbz2-dev \
	mosquitto \
	mosquitto-clients \
	nodejs \
	git \
	make \
	g++ \
	gcc

wget https://www.python.org/ftp/python/3.10.9/Python-3.10.9.tgz
tar -xf Python-3.10.*.tgz
cd Python-3.10.*/
./configure --enable-optimizations
make -j 4
sudo make altinstall

cd /tmp
echo "Installing dependencies"

sudo apt install -y python3-pip \
	python3-venv

echo "Installing docker"

if ! [ -x "$(command -v docker)" ]; then
	curl -fsSL get.docker.com | sh
else
	echo "Docker is already installed"
fi

echo "Installing OS Agent"
wget -O os-agent.deb https://github.com/home-assistant/os-agent/releases/download/1.4.1/os-agent_1.4.1_linux_x86_64.deb
sudo dpkg -i os-agent.deb

echo "Setting config for mosquitto"
echo '' | sudo tee -a /etc/mosquitto/mosquitto.conf
echo 'listener 1883' | sudo tee -a /etc/mosquitto/mosquitto.conf
echo 'allow_anonymous true' | sudo tee -a /etc/mosquitto/mosquitto.conf
sudo sed  -i '5i per_listener_settings true' /etc/mosquitto/mosquitto.conf

sudo systemctl restart mosquitto

echo "Setting config for zigbee2mqtt"
sudo curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo mkdir /opt/zigbee2mqtt
sudo chown -R ${USER}: /opt/zigbee2mqtt
git clone --depth 1 https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt

# Install dependencies (as user)
cd /opt/zigbee2mqtt
npm ci

echo "Changing configuration for zigbee2mqtt"
echo 'frontend: true' | tee -a /opt/zigbee2mqtt/data/configuration.yaml
echo '' | tee -a /opt/zigbee2mqtt/data/configuration.yaml
echo '' | tee -a /opt/zigbee2mqtt/data/configuration.yaml

echo 'advanced:' | tee -a /opt/zigbee2mqtt/data/configuration.yaml
echo '  network_key: GENERATE' | tee -a /opt/zigbee2mqtt/data/configuration.yaml

sudo mv ./zigbee2mqtt.service /etc/systemd/system/zigbee2mqtt.service
sudo systemctl reload zigbee2mqtt
sudo systemctl start zigbee2mqtt
sudo systemctl enable zigbee2mqtt
