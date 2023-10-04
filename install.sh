#!/bin/bash
if [[ "$1" = "" ]]; then
  echo "Missing domain name"
  exit 1
fi

sudo su
apt update

# install node
install -y ca-certificates curl gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=18
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
apt update
apt install nodejs -y


#install nginx
apt install nginx -y

#add website config
cat site.conf > /etc/nginx/sites-available/$1
systemctl restart nginx


#add ssl for nginx
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
certbot --nginx