#!/bin/bash

#set -e
COL='\033[1;32m'
NC='\033[0m' # No Color
echo -e "${COL}Setting up moonraker"

echo -e "${COL}Installing dependencies...\n${NC}"
apk add curl curl-dev jpeg-dev python3-dev py3-lmdb py3-wheel

echo -e "${COL}Downloading moonraker\n${NC}"
mv /moonraker /moonraker-backup || true
git clone --depth 1 https://mirror.ghproxy.com/https://github.com/Arksine/moonraker /moonraker

pip install virtualenv
virtualenv /moonraker-env
source /moonraker-env/bin/activate
pip install -r /moonraker/scripts/moonraker-requirements.txt
deactivate

mkdir -p /root/klipper_config
cp moonraker.conf /root/klipper_config/

echo -e "${COL} Applying special sauce${NC}"
sed -i 's/max_dbs=MAX_NAMESPACES)/max_dbs=MAX_NAMESPACES, lock=False)/' /moonraker/moonraker/components/database.py

mkdir -p /root/extensions/moonraker
cat << EOF > /root/extensions/moonraker/manifest.json
{
        "title": "Moonraker plugin",
        "description": "Requires Klipper"
}
EOF

cat << EOF > /root/extensions/moonraker/start.sh
#!/bin/sh
LD_PRELOAD=/home/octoprint/ioctlHook.so /moonraker-env/bin/python3 /moonraker/moonraker/moonraker.py -l /tmp/moonraker.log
EOF

cat << EOF > /root/extensions/moonraker/kill.sh
#!/bin/sh
pkill -f 'moonraker\.py'
EOF

chmod +x /root/extensions/moonraker/start.sh
chmod +x /root/extensions/moonraker/kill.sh

mkdir -p /home/octoprint/gcode_files

cat << EOF
Moonraker installed!
EOF
