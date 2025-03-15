#!/bin/sh

set -e

# switch mirror for mainland China users
# should be run before setup-octo4a.sh

sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
apk update
apk add py3-pip git tzdata
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone

# to support scp
apk add openssh
