#!/usr/bin/env bash
set -e

echo ${CODE_REPO}
echo ${CODE_BRANCH}
#初始化code用
if [ x${CODE_REPO} != x ]; then
    if [ ! -d /opt/hybris/bin/custom/hep ]; then
        #先clone develop分支
        BRANCH=" -b ${CODE_BRANCH}"
        git clone ${BRANCH} ${CODE_REPO}  /opt/hybris/bin/custom/${CODE_DIRECTORY}

        if [ "$?" == "0" ]; then
               echo "Clone  $BRANCH $CODE_REPO  成功"
        fi
    else
        #工程存在  更新工程
        cd /opt/hybris/bin/custom/hep && git pull
    fi
fi
