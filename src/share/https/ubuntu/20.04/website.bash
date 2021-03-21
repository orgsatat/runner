#!/bin/bash
set -euo pipefail

SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the
  # path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIRECTORY="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
LIBRARY_DIRECTORY=$SCRIPT_DIRECTORY/../lib/satat/


if [ "$#" -ne 3 ]; then
  echo "Script requires:"
  echo "1. Website Name"
  echo "2. Username"
  echo "3. Email"
  exit 1
fi

WEBSITE=$1
USERNAME=$2
EMAIL=$3

apt-get install -y nginx
ufw allow "Nginx Full"
mkdir -p /srv/https/$WEBSITE

cat > a <<- EOM
$WEBSITE
EOM

sudo chown -vR $USERNAME:$USERNAME /srv/https/$WEBSITE

cat > /etc/nginx/sites-available/$WEBSITE <<- EOM
server {
  listen 80;
  listen [::]:80;

  root /srv/https/$WEBSITE;
  index index.html

  server_name $WEBSITE;

  location / {
    try_files $uri $uri/ =404;
  }
}
EOM

ln -s /etc/nginx/sites-available/$WEBSITE /etc/nginx/sites-enabled/$WEBSITE
unlink /etc/nginx/sites-enabled/default

certbot --nginx -n -d $WEBSITE --agree-tos --redirect -m $EMAIL
