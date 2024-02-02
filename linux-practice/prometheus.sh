#!/bin/bash  
set -ex
echo 'Installing prometheus ...'

wget https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-amd64.tar.gz
tar -xvf prometheus-2.43.0.linux-amd64.tar.gz 

prometheus_directory=prometheus-2.43.0.linux-amd64/   
if [ -d "$prometheus_directory" ]; then 
  cd $prometheus_directory
  sudo cp prometheus /usr/local/bin/
  sudo cp promtool /usr/local/bin/


  ls
  sudo rm -rf /etc/prometheus/
  sudo mkdir /etc/prometheus

  sudo cp -r consoles /etc/prometheus/
  sudo cp -r console_libraries /etc/prometheus/
  sudo cp prometheus.yml /etc/prometheus/

  if ! id prometheus; then
    sudo useradd --shell /bin/false prometheus
  else
    echo  'User promethues already exists'
  fi    

  ls /etc/prometheus

  #setting prometheus as moved directories user
  sudo chown prometheus:prometheus /usr/local/bin/prometheus 
  sudo chown prometheus:prometheus /usr/local/bin/promtool
  sudo chown prometheus:prometheus /etc/prometheus/consoles
  sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml 
  sudo chown prometheus:prometheus /etc/prometheus/console_libraries
    
  cd ../

  sudo rm -rf /var/lib/prometheus
  sudo mkdir /var/lib/prometheus

  sudo chown prometheus:prometheus /var/lib/prometheus/
  sudo chown -R  prometheus:prometheus /var/lib/prometheus/
  sudo chown -R  prometheus:prometheus /etc/prometheus/consoles
  sudo chown -R  prometheus:prometheus /etc/prometheus/console_libraries/

  #creating promethues.service file 
  sudo tee /etc/systemd/system/prometheus.service<<EOF
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

  #removing extracted files
  sudo rm -rf prometheus-2.43.0.linux-amd64* 

  sudo systemctl daemon-reload 
  sudo systemctl enable prometheus.service 
  sudo systemctl start prometheus.service 
      
  echo 'Promethus is successfully installed is runnning under http://localhost:9090 URL'
else
  echo "Extracting Promethues wasn't successful, Please check your permissions manually" 
fi    
