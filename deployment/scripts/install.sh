#!/bin/bash
set -e
# Update system packages
yum update -y

# Install Nginx and other essentials
yum install -y nginx openssl wget

# Install Python 3.13 from Amazon Linux Extras
yum install -y python3.13 python3.13-pip


# Upgrade pip and install pipenv for root
python3.13 -m pip install --upgrade pip
python3.13 -m pip install pipenv

# Upgrade pipenv for ec2-user
sudo -u ec2-user python3.13 -m pip install --upgrade pip
sudo -u ec2-user python3.13 -m pip install pipenv

# Enable and start Nginx
systemctl daemon-reload
systemctl enable nginx
systemctl start nginx
