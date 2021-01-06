
echo "Boxie installer - UBUNTU-20.04LTS"

apt-get update
apt-get install -y \
   wget curl software-properties-common cron \
   build-essential certbot git incron \
   libjpeg-dev libxml2-dev libxslt1-dev zlib1g-dev nginx-full \
   python3-certbot-nginx python-dev \
   python3-dev python3-pip python3-click python3-virtualenv \
   uwsgi uwsgi-plugin-asyncio-python3 \
   uwsgi-plugin-python3 uwsgi-plugin-tornado-python3 \
   python-yaml php-fpm nodejs npm nodeenv
apt-get update

PAAS_USERNAME=boxie

# Create user
sudo adduser --disabled-password --gecos 'PaaS access' --ingroup www-data $PAAS_USERNAME

# copy your public key to /tmp (assuming it's the first entry in authorized_keys)
head -1 ~/.ssh/authorized_keys > /tmp/pubkey
# install boxie and have it set up SSH keys and default files
sudo su - $PAAS_USERNAME -c "wget https://raw.githubusercontent.com/mardix/boxie/master/boxie.py && python3 ~/boxie.py init && python3 ~/boxie.py set-ssh /tmp/pubkey"
rm /tmp/pubkey


sudo ln /home/$PAAS_USERNAME/.boxie/uwsgi/uwsgi.ini /etc/uwsgi/apps-enabled/boxie.ini
sudo systemctl restart uwsgi

cd /tmp
wget https://raw.githubusercontent.com/mardix/boxie/master/incron.conf
wget https://raw.githubusercontent.com/mardix/boxie/master/nginx.conf
cp /tmp/nginx.conf /etc/nginx/sites-available/default
cp /tmp/incron.conf /etc/incron.d/boxie

echo ""
echo "Boxie installation complete!"