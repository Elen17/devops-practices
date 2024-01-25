#!/bin/bash
echo 'Starting node-exporter installation'
   wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz

    tar xvf node_exporter-1.3.1.linux-amd64.tar.gz   
    cd node_exporter-1.3.1.linux-amd64/
    mv node_exporter /usr/local/bin/
    sudo mv node_exporter /usr/local/bin/
    cd ../
    rm -rf node_exporter-1.3.1.linux-amd64
    sudo useradd --shell /bin/false node_exporter
    sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter       
    sudo tee /etc/systemd/system/node_exporter.service<<EOF
[Unit]
Description=Node Exporter
After=network.target
 
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
 
[Install]
WantedBy=multi-user.target
EOF
    sudo systemctl daemon-reload 
    sudo systemctl enable node_exporter.service   
    sudo systemctl start node_exporter.service      
echo  'Node-exporter installation is complete'

