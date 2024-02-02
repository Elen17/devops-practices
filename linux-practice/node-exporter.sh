#!/bin/bash
set -ex

echo 'Starting node-exporter installation'

wget -P /tmp https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvf /tmp/node_exporter-1.3.1.linux-amd64.tar.gz -C /tmp

node_directory="/tmp/node_exporter-1.3.1.linux-amd64"
if [ -d "$node_directory" ]; then
    sudo mv "$node_directory/node_exporter" /usr/local/bin/
    rm -rf "$node_directory"

    # Create node_exporter user if not exist
    if ! id -u node_exporter &>/dev/null; then
        echo 'Creating node_exporter user and group'
        sudo useradd --shell /bin/false node_exporter
        sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
    else
        echo 'User node_exporter already exists'
    fi

    #removing extracted files
    rm -rf node_exporter-1.3.1.linux-amd64*
    sudo rm -f /etc/systemd/system/node_exporter.service

    sudo tee /etc/systemd/system/node_exporter.service <<EOF
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
        sudo systemctl enable node_exporter
        sudo systemctl start node_exporter
        echo 'Node-exporter is installed and is running under http://localhost:9100/ URL'
    
else
    echo "Directory $node_directory wasn't created. Installation is interrupted."
fi
