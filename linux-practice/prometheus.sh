#!/bin/bash  
echo 'Installing prometheus ...'

    wget https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-amd64.tar.gz
   
    sudo useradd --shell /bin/false prometheus
    
    tar -xvf prometheus-2.43.0.linux-amd64.tar.gz 
    cd prometheus-2.43.0.linux-amd64/
    sudo mv prometheus /usr/local/bin/
    sudo mv promtool /usr/local/bin/
    sudo chown prometheus:prometheus /usr/local/bin/prometheus 
    sudo chown prometheus:prometheus /usr/local/bin/promtool 
    sudo mv consoles /etc/prometheus
    sudo mv console_libraries /etc/prometheus
    sudo mv prometheus.yml /etc/prometheus
    
   
    cd ../
   
    tar -xvf prometheus-2.43.0.linux-amd64.tar.gz 
    cd prometheus-2.43.0.linux-amd64/
   
    sudo cp consoles /etc/prometheus/
    sudo cp -r  consoles /etc/prometheus/
    sudo chown prometheus:prometheus /etc/prometheus/consoles
    sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml 
    sudo chown prometheus:prometheus /etc/prometheus/console_libraries/
    sudo mkdir /var/lib/prometheus
    sudo chown prometheus:prometheus /var/lib/prometheus/
    sudo chown -R  prometheus:prometheus /var/lib/prometheus/
    sudo chown -R  prometheus:prometheus /etc/prometheus/consoles
    sudo chown -R  prometheus:prometheus /etc/prometheus/console_libraries/
    sudo vim /etc/prometheus/prometheus.yml 
    sudo tee  /etc/systemd/system/prometheus.service<<EOF
     [Unit]
     Description=Prometheus
     Wants=network-online.target
     After=network-online.target

     [Service]
     User=prometheus
     Group=prometheus
     Type=simple
     ExecStart=/usr/local/bin/prometheus \
       --config.file /etc/prometheus/prometheus.yml \
       --storage.tsdb.path /var/lib/prometheus/ \
       --web.console.templates=/etc/prometheus/consoles \
       --web.console.libraries=/etc/prometheus/console_libraries

       [Install]
       WantedBy=multi-user.target
    
EOF

    cd ../
   
    rm -rf node_exporter-1.3.1.linux-amd64.tar.gz 
    sudo systemctl daemon-reload 
    sudo systemctl enable prometheus.service 
    sudo systemctl start prometheus.service 
    
    echo 'Promethus is successfully installed'
