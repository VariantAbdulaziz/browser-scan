#!/bin/bash
set -e

cd /home/ec2-user/app
source /home/ec2-user/.bash_profile

TEMPLATE="/home/ec2-user/app/deployment/config/GeoIP.conf.template"
TARGET="/usr/local/etc/GeoIP.conf"

sudo cp "$TEMPLATE" "$TARGET"

sudo sed -i "s/{{MAXMIND_ACCOUNT_ID}}/${MAXMIND_ACCOUNT_ID}/g" "$TARGET"
sudo sed -i "s/{{MAXMIND_LICENSE_KEY}}/${MAXMIND_LICENSE_KEY}/g" "$TARGET"

echo "/usr/local/etc/GeoIP.conf created successfully."

sudo crontab -e
geoipupdate -v

42 21 * * 6,3 /usr/local/bin/geoipupdate
