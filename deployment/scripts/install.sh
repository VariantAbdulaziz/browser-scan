#!/bin/bash
set -e
# Update system packages
yum update -y

DOCKER_COMPOSE_VERSION="2.40.1"

# Install Nginx and other essentials
yum install -y nginx openssl wget docker
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Install Python 3.13 from Amazon Linux Extras
yum install -y python3.13 python3.13-pip

# Upgrade pip and install pipenv for root
python3.13 -m pip install --upgrade pip
python3.13 -m pip install pipenv

# Upgrade pipenv for ec2-user
sudo -u ec2-user python3.13 -m pip install --upgrade pip
sudo -u ec2-user python3.13 -m pip install pipenv

systemctl daemon-reload

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx || true

# Enable and start Docker
systemctl enable docker
systemctl start docker
