#!/bin/bash

# Install and configure docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker ubuntu
sudo useradd -G docker discourse
sudo usermod -aG docker discourse

sudo apt update
sudo apt upgrade -y
# Install prerequisities
sudo apt --yes install git

# Configure and build discourse
sudo git clone https://github.com/discourse/discourse_docker.git /var/discourse
sed -i "s/REPLACE_WITH_DB_URL/$DB_URL/g" /home/ubuntu/app.yml
sudo cp /home/ubuntu/app.yml /var/discourse/containers/
sudo chown -R discourse:discourse /var/discourse/
cd /var/discourse && sudo ./launcher rebuild app
