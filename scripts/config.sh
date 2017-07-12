#!/usr/bin/env bash
set -e

ASPECT_NAME=$1

ant createConfig  -Dinput.template=develop

#替换对应的文件
cp -R /u01/aspects/${ASPECT_NAME}/hybris/conf/. /u01/hybris/config
