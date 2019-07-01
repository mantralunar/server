#Remove existing/previous installation
systemctl stop jdownloader.service
systemctl disable jdownloader.service
rm /etc/systemd/system/jdownloader.service
systemctl daemon-reload
rm -R /opt/jdownloader/

#jDownloader2 First Launch
mkdir -p /opt/jdownloader/
wget -O /opt/jdownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar"
chmod a+x /opt/jdownloader/JDownloader.jar
java -jar /opt/jdownloader/JDownloader.jar -norestart

#Systemd Unit
cat <<EOT >> /etc/systemd/system/jdownloader.service
[Unit]
Description=JDownloader Service
After=network.target

[Service]
Environment=JD_HOME=/opt/jdownloader
Type=oneshot
ExecStart=/usr/bin/java -Djava.awt.headless=true -jar /opt/jdownloader/JDownloader.jar
RemainAfterExit=yes
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl enable jdownloader.service
systemctl daemon-reload
sudo systemctl start jdownloader.service
