cd /tmp

echo "Updating apt"
sudo apt -y update
sudo apt -y upgrade

echo "Installing dependencies"

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
	python3-pip \
	python3-venv \
	libssl-dev

echo "Installing docker"
curl -fsSL get.docker.com | sh

echo "Installing OS Agent"
wget -O os-agent.deb https://github.com/home-assistant/os-agent/releases/download/1.4.1/os-agent_1.4.1_linux_x86_64.deb
sudo dpkg -i os-agent.deb
