#!/usr/bin/env bash
set -e

ASPECT_NAME=$1
cd ${PLATFORM_HOME} && source setantenv.sh

ant createConfig  -Dinput.template=develop

#替换对应的文件
cp -R /u01/aspects/${ASPECT_NAME}/hybris/conf/. /u01/hybris/config

echo "Config设置完成"
