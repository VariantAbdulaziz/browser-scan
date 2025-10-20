#!/bin/bash
set -e

cd /home/ec2-user/app
source /home/ec2-user/.bash_profile

sudo mkdir -p /home/ec2-user/app/staticfiles
sudo chown -R ec2-user:ec2-user /home/ec2-user/app/staticfiles

sudo mkdir -p /etc/nginx/conf.d
sudo cp -f /home/ec2-user/app/deployment/config/nginx.conf /etc/nginx/conf.d/default.conf

DOMAIN="mutation.cc"
EMAIL="variant.abdulaziz@gmail.com"

sudo systemctl daemon-reload

sudo yum install -y certbot
sudo systemctl stop nginx
sudo certbot certonly --non-interactive --agree-tos \
    --standalone -d "$DOMAIN" -m "$EMAIL" --preferred-challenges http


CERT="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
KEY="/etc/letsencrypt/live/$DOMAIN/privkey.pem"

sudo chmod 600 "$KEY"
sudo chmod 644 "$CERT"

python3.13 -m pipenv install --deploy --ignore-pipfile

python3.13 -m pipenv run python manage.py migrate
python3.13 -m pipenv run python manage.py collectstatic --noinput

# Ensure Nginx can read static files
sudo mkdir -p /var/www/staticfiles
sudo cp -r /home/ec2-user/app/staticfiles/* /var/www/staticfiles/

pkill -f daphne || true

sudo mkdir -p /home/ec2-user/app/logs
sudo chown -R ec2-user:ec2-user /home/ec2-user/app/logs
sudo chmod 755 /home/ec2-user/app/logs
nohup python3.13 -m pipenv run daphne -b 127.0.0.1 -p 8000 core.asgi:application \
    > /home/ec2-user/app/logs/daphne.log 2>&1 &

sleep 5
if ! pgrep -f "daphne.*core.asgi:application" > /dev/null; then
    echo "Daphne failed to start — exiting."
    exit 1
fi

sudo nginx -t
sudo systemctl restart nginx
