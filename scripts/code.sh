##!/usr/bin/env bash
#set -e
#
##初始化code用
#    CODE_REPO=$1
#    ASPECT_NAME=$2
#    if [ "$CODE_REPO" != "" ]; then
#        if [ ! -d /opt/hybris/bin/custom/hep ]; then
#
#        #先clone develop分支
#        git clone -b develop $CODE_REPO
#
#        if [ "$?" == "0" ]; then
#               echo "Clone Develop 分支成功"
#        else
#             #如果工程不存在
#            . generateCode.sh "$ASPECT_NAME";
#            #不为演示环境的时候提交到git上
#            cd /opt/hybris/bin/custom/hep
#
#            git init
#            git add .
#            git commit -m "first commit"
#            git remote add origin $CODE_REPO
#            git push -u origin master
#            echo "成功推送 CodeRepo ：$CODE_REPO 成功"
#        fi
#
#
#        #mkdir /opt/hybris/custom
#     else
#        #工程存在  更新工程
#        cd /opt/hybris/bin/custom/hep && git pull
#     fi
#    else
#       . generateCode.sh "$ASPECT_NAME";
#    fi
#
