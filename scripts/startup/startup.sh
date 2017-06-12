#!/bin/bash
set -e


#环境准备





#下载准备好的源码
if [ ! -d /u01/hybris/bin ];then
    mkdir -p /u01/hybris/binaries/$HYBRIS_VERSION/
    if [ ! -f /u01/hybris/binaries/$HYBRIS_VERSION/$ASPECT_NAME.zip ];then
        echo "采用Volume代替下载"
        #采用下载太慢了  而且没有文件服务器支持
       # curl -k -C - -o /u01/hybris/binaries/$HYBRIS_VERSION/$ASPECT_NAME.zip sftp://hybris:hybris@121.196.204.147:56771/u01/package/binaries/$HYBRIS_VERSION/$ASPECT_NAME.zip
    fi

    unzip -o -d  /u01/hybris /u01/hybris/binaries/$HYBRIS_VERSION/$ASPECT_NAME.zip
fi

#初始化code

#. scripts/code.sh "$CODE_REPO" "$ASPECT_NAME";

#初始化Hybris Config，从Git或默认中读取
#. scripts/config.sh "$CONFIG_REPO" "$ASPECT_NAME";

#设置addon
#echo "开始Addon的设置：$B2B_ADDONS $B2C_ADDONS"
#cd /u01/aspects/${ASPECT_NAME}/hybris/conf && ./addons.sh


#阻塞直至等待端口打开
yWaitForPort.sh $WAIT_FOR


#jvm route   负载均衡使用
if [ "$JVM_ROUTE" == "dynamic" ]; then

fi

##admin aspect  用来执行ant命令 第二个参数为命令  需要在宿主机执行 若Jenkins独立的话  如何
#if [ "$ASPECT_NAME" == "admin" ]; then
#	# we use cd because setantenv.sh uses `pwd` to export PLATFORM_HOME
#	cd ${PLATFORM_HOME} && source setantenv.sh
#	ant -Dde.hybris.platform.ant.production.skip.build=true -buildfile $PLATFORM_HOME "${@:2}"
#else
#    echo "开始进行Hybris设置"
#
#    cd ${PLATFORM_HOME} && source setantenv.sh
#    cat /u01/hybris/config/localextensions.xml
#    ant clean all
#
#    /u01/tomcat/bin/catalina.sh ${2:-run}
#fi



