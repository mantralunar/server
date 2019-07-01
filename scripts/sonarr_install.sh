#Remove previous Sonarr Install
systemctl stop sonarr.service
systemctl disable sonarr.service
rm /etc/systemd/system/sonarr.service
systemctl daemon-reload

#Download and Installation
wget http://download.sonarr.tv/v3/phantom-develop/3.0.1.526/Sonarr.phantom-develop.3.0.1.526.linux.tar.gz -P /tmp/
tar xf /tmp/Sonarr.phantom-develop.3.0.1.526.linux.tar.gz -C /opt/
rm /tmp/Sonarr.phantom-develop.3.0.1.526.linux.tar.gz

#Systemd Unit
cat <<EOT >> /etc/systemd/system/sonarr.service
[Unit]
Description=Sonarr Daemon
After=network.target

[Service]
User=root
Group=root

Type=simple
ExecStart=/usr/bin/mono /opt/Sonarr/Sonarr.exe -nobrowser
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT

systemctl enable sonarr.service
systemctl daemon-reload
systemctl start sonarr.service
