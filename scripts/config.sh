#!/usr/bin/env bash
set -e

echo ${CONFIG_REPO}
echo ${CONFIG_BRANCH}
#初始化code用
if [ x${CONFIG_REPO} != x ]; then
    if [ ! -d /opt/hybris/config ]; then
        #先clone develop分支
        BRANCH=" -b ${CONFIG_BRANCH}"
        git clone ${BRANCH} ${CONFIG_REPO}  /opt/hybris/config

        if [ "$?" == "0" ]; then
               echo "Clone  $BRANCH $CONFIG_REPO  成功"
        fi
    else
        #工程存在  更新工程
        cd /opt/hybris/config && git pull
    fi
fi
