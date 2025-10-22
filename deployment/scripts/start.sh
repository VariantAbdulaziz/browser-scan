#!/bin/bash
set -e

cd /home/ec2-user/app
source /home/ec2-user/.bash_profile

mkdir -p /home/ec2-user/app/staticfiles

mkdir -p /etc/nginx/conf.d
cp -f /home/ec2-user/app/deployment/config/nginx.conf /etc/nginx/conf.d/default.conf

DOMAIN="api.mutation.cc"
EMAIL="variant.abdulaziz@gmail.com"

systemctl daemon-reload

# Install certbot itself via yum
yum install -y python3-certbot


python3.13 -m pipenv install --deploy --ignore-pipfile
systemctl stop nginx

python3.13 -m pipenv run certbot certonly \
    --non-interactive --agree-tos \
    --email "$EMAIL" \
    --standalone \
    -d "$DOMAIN" \
    --preferred-challenges http

TMP_CREDENTIALS="/home/ec2-user/app/.tmp/cloudflare.ini"
mkdir -p /home/ec2-user/app/.tmp
echo "dns_cloudflare_api_token = $DNS_CLOUDFLARE_API_TOKEN" > "$TMP_CREDENTIALS"
chmod 600 "$TMP_CREDENTIALS"

cat "$TMP_CREDENTIALS"

python3.13 -m pipenv run certbot certonly \
    --non-interactive --agree-tos \
    --email "$EMAIL" \
    --dns-cloudflare --dns-cloudflare-credentials "$TMP_CREDENTIALS" \
    -d "*.test.${DOMAIN}"

rm -f "$TMP_CREDENTIALS"

CERT="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
KEY="/etc/letsencrypt/live/$DOMAIN/privkey.pem"
TESTCERT="/etc/letsencrypt/live/test.$DOMAIN/fullchain.pem"
TESTKEY="/etc/letsencrypt/live/test.$DOMAIN/privkey.pem"

chmod 600 "$KEY"
chmod 644 "$CERT"
chmod 600 "$TESTKEY"
chmod 644 "$TESTCERT"

pkill -f daphne || true
sudo fuser -k 53/tcp || true
sudo fuser -k 53/udp || true

python3.13 -m pipenv run python manage.py migrate
python3.13 -m pipenv run python manage.py collectstatic --noinput

# Ensure Nginx can read static files
mkdir -p /var/www/staticfiles
cp -r /home/ec2-user/app/staticfiles/* /var/www/staticfiles/



mkdir -p /home/ec2-user/app/logs
chmod 755 /home/ec2-user/app/logs
nohup python3.13 -m pipenv run daphne -b 127.0.0.1 -p 8000 core.asgi:application \
    > /home/ec2-user/app/logs/daphne.log 2>&1 &

sleep 5
if ! pgrep -f "daphne.*core.asgi:application" > /dev/null; then
    echo "Daphne failed to start — exiting."
    exit 1
fi

nginx -t
systemctl restart nginx
