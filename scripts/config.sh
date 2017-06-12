#!/usr/bin/env bash
set -e
#初始化config使用
    CONFIG_REPO=$0
    ASPECT_NAME=$1
echo "初始化Config：$CONFIG_REPO"
if [ "$CONFIG_REPO" != "" ];then
  #提供了config repo的时候，从git上拉下来 或者传到git上
  echo "Pull Config From Git :$CONFIG_REPO "
  if [ ! -d /opt/config ]; then
        #当/opt/config不存在的时候  两种情况：1.从未clone   2.git 仓库未初始化
        #克隆至临时目录
        git clone -b develop  $CONFIG_REPO "/opt/config"
        if [ "$?" -ne "0" ];then
            echo "开始准备初始化远程config仓库"
            #git仓库未初始化
            mkdir /opt/config
            cp /opt/aspects/${ASPECT_NAME}/hybris/conf/local.properties /opt/config
            cp /opt/aspects/${ASPECT_NAME}/hybris/conf/localextensions.xml /opt/config
            cd /opt/config
            git init
            git add .
            git commit -m "first commit"
            git remote add origin $CONFIG_REPO
            git push -u origin develop
            echo "成功推送 ConfigRepo ：$CONFIG_REPO 成功"
        else
            #克隆成功
            echo "克隆ConfigRepo ：$CONFIG_REPO 成功"
        fi
  else
        echo "更新config"
        cd /opt/config
        git pull
  fi
else
    #此时为演示环境，将标准的localextension.xml和local.properties拷贝到/opt/config
    echo "使用自带的config文件"
    mkdir /opt/config
    cp /opt/aspects/${ASPECT_NAME}/hybris/conf/local.properties /opt/config
    cp /opt/aspects/${ASPECT_NAME}/hybris/conf/localextensions.xml /opt/config

fi

cp -R /opt/config/. /opt/hybris/config