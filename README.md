# Octo4a Klipper

## Install

因为安装过程要从 GitHUb 下载文件，需要科学上网

1. Install [octo4a](https://github.com/feelfreelinux/octo4a/releases) Android app
2. Open the installed Octo4a
3. Install OctoPrint
    1. Install bootstrap
    2. Download OctoPrint
    3. Install dependencies
4. Goto settings to enable OpenSSH server
5. SSH to the Linux environment inside octo4a

> *TODO*

``` sh
git clone ...
cd octo4a-klipper
sh -C prepare.sh
sh -C setup-klipper.sh
sh -C setup-moonraker.sh
sh -C setup-fluidd.sh
sh -C setup-KlipperScreen.sh
```

## How to Use

### Compile and Flash Firmware

Connect with SSH then run below commands.

For the first time, install build environment:
```
bash setup-build-environment.sh
```

Build firmware:
```
cd /klipper
make menuconfig
make
```

Flash the firmware to printer control board:
```
make flash FLASH_DEVICE=/dev/ttyOcto4a
```

### 控制网页
<http://手机IP:8080>

### web终端
<http://手机IP:5002>

### 摄像头配置

- <http://手机IP:5001/mjpeg>
- <http://手机lP:5001/snapshot>

### printer.cfg配置

```
[mcu]
serial:/dev/ttyOcto4a
# baud: 115200 #（非必须，默认波特率连不上可改为115200）

[virtual_sdcard]
path: /home/octoprint/gcode_files
```
