#!/bin/bash
set -e

cd /home/ec2-user/app
source /home/ec2-user/.bash_profile

sudo mkdir -p ./secrets
sudo chown -R ec2-user:ec2-user /home/ec2-user/app/secrets

# Create Docker secrets
echo "${MAXMIND_ACCOUNT_ID}" > ./secrets/MAXMIND_ACCOUNT_ID.txt
echo "${MAXMIND_LICENSE_KEY}" > ./secrets/MAXMIND_LICENSE_KEY.txt

sudo docker-compose up -d geoipupdate

GEOIP_DIR="./geoip-data"
FILES=("GeoLite2-ASN.mmdb" "GeoLite2-City.mmdb" "GeoLite2-Country.mmdb")
WAIT_SECONDS=5

echo "Waiting for GeoIP databases to be downloaded..."

while true; do
    MISSING=()
    for f in "${FILES[@]}"; do
        if [ ! -f "$GEOIP_DIR/$f" ]; then
            MISSING+=("$f")
        fi
    done

    if [ ${#MISSING[@]} -eq 0 ]; then
        echo "All GeoIP databases found in $GEOIP_DIR."
        break
    else
        echo "Still waiting for: ${MISSING[*]}"
        sleep $WAIT_SECONDS
    fi
done
