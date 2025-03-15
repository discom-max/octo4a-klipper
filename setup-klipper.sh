#!/bin/bash
#set -e
COL='\033[1;32m'
NC='\033[0m' # No Color
echo -e "${COL}Setting up klipper"

echo -e "${COL}Installing dependencies...\n${NC}"
apk add python3-dev build-base gcc g++ py3-cffi py3-greenlet linux-headers can-utils git libusb-dev ncurses-dev libffi-dev avrdude gcc-avr binutils-avr avr-libc stm32flash newlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi libusb pkgconfig

echo -e "${COL}Downloading klipper\n${NC}"
mv /klipper /klipper-backup || true
git clone --depth 1 https://gitee.com/miroky/klipper.git /klipper

pip install virtualenv
virtualenv /klipper-env
source /klipper-env/bin/activate
pip install -r /klipper/scripts/klippy-requirements.txt
deactivate

mv /root/klipper_config /root/klipper_config-backup || true
mkdir /root/klipper_config
echo "# replace with your config" >> /root/klipper_config/printer.cfg

mkdir -p /root/extensions/klipper
cat << EOF > /root/extensions/klipper/manifest.json
{
        "title": "Klipper plugin",
        "description": "Requires OctoKlipper plugin"
}
EOF

cat << EOF > /root/extensions/klipper/start.sh
#!/bin/sh
/klipper-env/bin/python3 /klipper/klippy/klippy.py /root/printer_data/config/printer.cfg -l /tmp/klippy.log -a /tmp/klippy_uds
EOF

cat << EOF > /root/extensions/klipper/kill.sh
#!/bin/sh
pkill -f 'klippy\.py'
EOF

chmod +x /root/extensions/klipper/start.sh
chmod +x /root/extensions/klipper/kill.sh

echo -e "${COL}\nKlipper installed! Please kill the app and restart it again to see it in extension settings${NC}"
