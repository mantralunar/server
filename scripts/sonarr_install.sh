#Remove previous Sonarr Install
systemctl stop sonarr.service
systemctl disable sonarr.service
rm /etc/systemd/system/sonarr.service
systemctl daemon-reload
rm -R /opt/Sonarr/

#Download and Installation
curl -L -o /tmp/Sonarr.phantom-develop.linux.tar.gz "https://services.sonarr.tv/v1/download/phantom-develop/latest?version=3&os=linux"
tar xf /tmp/Sonarr.phantom-develop.linux.tar.gz -C /opt/
rm /tmp/Sonarr.phantom-develop.linux.tar.gz

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
