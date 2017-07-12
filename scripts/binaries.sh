#!/usr/bin/env bash

set -e
#生成相应的工程

ASPECT_NAME=$1


 if [ ! -d /u01/hybirs ]; then
    echo "开始解压对应的文件夹"
    unzip -o -d  /u01 /u01/packages/binaries/HYBRIS.zip
fi

rm -rf /u01/hybris/bin/custom
rm -rf /u01/hybris/config
rm -rf /u01/hybris/data
rm -rf /u01/hybris/log
rm -rf /u01/hybris/roles
rm -rf /u01/hybris/temp