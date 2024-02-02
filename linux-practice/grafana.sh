#!/bin/bash  
set -ex

echo 'Installing Grafana ...'

wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

sudo apt install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
          
#sudo apt purge grafana
#sudo apt autoremove
sudo apt install grafana
sudo grafana-server -v
sudo systemctl enable grafana-server.service 
sudo systemctl start grafana-server.service 

echo 'Grafana is successfully installed is runnning under http://localhost:3000 URL'
echo 'Default admin/password: admin/admin'
    
