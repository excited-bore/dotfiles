# https://serverfault.com/questions/1017577/profile-d-script-permission-denied 
sudo mkdir /etc/rc.local
sudo chmod u+x /etc/rc.local
sudo mkdir /etc/systemd/system/rc-local.service.d/
sudo touch /etc/systemd/system/rc-local.service.d/enable.conf
sudo sh -c "printf \"[Install]\nWantedBy=multi-user.target\" > /etc/systemd/system/rc-local.service.d/enable.conf"
sudo systemctl enable --now rc-local
