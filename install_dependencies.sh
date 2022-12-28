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
	libbz2-dev

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
