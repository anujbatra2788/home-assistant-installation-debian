#!/usr/bin/env bash

HA_BASE_PATH=/srv/homeassistant
HA_USER=home
HA_SYSTEMD_FILE_PATH=/etc/systemd/system/home-assistant@$HA_USER.service
HA_TMP_SYSTEMD_FILE_PATH=./home-assistant@$HA_USER.service

fnc_create_ha_instance() {
	set -e
	sudo rm -rf $HA_BASE_PATH
	sudo mkdir -p $HA_BASE_PATH
	sudo chown -R $HA_USER:$HA_USER $HA_BASE_PATH
	cd $HA_BASE_PATH
	python3 -m venv .
	source bin/activate
	pip3 install homeassistant
	deactivate
}

fnc_create_systemd_service() {
	sudo rm $HA_SYSTEMD_FILE_PATH

	sudo echo '[Unit]' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo 'Description=Home Assistant' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo 'After=network-online.target' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo '' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo '[Service]' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo 'Type=simple' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo 'User=%i' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo 'WorkingDirectory=/home/%i/.homeassistant' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo 'ExecStart=/srv/homeassistant/bin/hass -c "/home/%i/.homeassistant"' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo 'RestartForceExitStatus=100' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo '' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo '[Install]' >> $HA_TMP_SYSTEMD_FILE_PATH;
	sudo echo 'WantedBy=multi-user.target' >> $HA_TMP_SYSTEMD_FILE_PATH;

	sudo cp $HA_TMP_SYSTEMD_FILE_PATH $HA_SYSTEMD_FILE_PATH

	sudo systemctl --system daemon-reload
	sudo systemctl enable home-assistant@$HA_USER
	sudo systemctl start home-assistant@$HA_USER
}

fnc_create_ha_sup_instance() {
	cd /tmp
	wget https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
	dpkg --force-confdef --force-confold -i homeassistant-supervised.deb
	cd -

}

fnc_start_ha() {
	set -e
	cd $HA_BASE_PATH
	source bin/activate
	hass	
}

fnc_create_ha_instance
fnc_create_ha_sup_instance
fnc_create_systemd_service
#fnc_start_ha
