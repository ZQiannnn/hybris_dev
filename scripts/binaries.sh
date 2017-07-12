#!/usr/bin/env bash

set -e
#生成相应的工程

ASPECT_NAME=$1

#ls -l $HYBRIS_HOME && exit
rm -rf $HYBRIS_HOME && mkdir -p /u01

echo "开始解压对应的文件夹"
unzip -o -d  /u01 /u01/packages/binaries/HYBRIS.zip
