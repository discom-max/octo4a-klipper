#!/bin/bash

set -e
COL='\033[1;32m'
NC='\033[0m' # No Color
echo -e "${COL}Setting up fluidd"

echo -e "${COL}Installing dependencies...\n${NC}"
apk add curl nginx openrc

echo -e "${COL}Downloading fluidd\n${NC}"
# Find the latest version on https://gitee.com/Neko-vecter/fluidd-releases/releases
curl -o /tmp/fluidd.zip -L https://gitee.com/Neko-vecter/fluidd-releases/releases/download/v1.27.0/fluidd.zip

echo -e "${COL}Extracting fluidd\n${NC}"
mv /fluidd /fluidd-backup || true
unzip /tmp/fluidd.zip -d /fluidd
rm -f /tmp/fluidd.zip

cp fluidd.conf /etc/nginx/http.d/

# TODO: sed nginx user root

# nginx serves ts as wrong mimetype
# video/mp2t                                       ts;
#text/javascript			ts;

mkdir -p /root/extensions/fluidd
cat << EOF > /root/extensions/fluidd/manifest.json
{
        "title": "fluidd plugin",
        "description": "klipper web interface"
}
EOF

cat << EOF > /root/extensions/fluidd/start.sh
#!/bin/sh
nginx
EOF

cat << EOF > /root/extensions/fluidd/kill.sh
#!/bin/sh
nginx -s stop
EOF

chmod +x /root/extensions/fluidd/start.sh
chmod +x /root/extensions/fluidd/kill.sh

cat << EOF
fluidd installed!
EOF