#!/usr/bin/env bash

set -e
#生成相应的工程

ASPECT_NAME=$1


 if [ ! -d /u01/hybirs ]; then
    echo "开始解压对应的文件夹"
    unzip -o -d  /u01 /u01/packages/binaries/HYBRIS.zip
fi