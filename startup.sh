#!/bin/bash
set -e


#环境准备

#设置tomcat运行参数
export CATALINA_OPTS="-DPLATFORM_HOME=$PLATFORM_HOME $CATALINA_SECURITY_OPTS $CATALINA_MEMORY_OPTS -Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=de.hybris.tomcat.EnvPropertySource $ADDITIONAL_CATALINA_OPTS"
#设置切面，没有的话用default
export ASPECT_NAME=${1:-b2c}

#设置tomcat工作目录  只启动一个tomcat实例
export CATALINA_BASE="/opt/aspects/tomcat"

#以aspect来控制hybris的conf
#export HYBRIS_OPT_CONFIG_DIR="/opt/aspects/$ASPECT_NAME/hybris/conf"


#参数检查

 #当提供了任意一个repo ，却没有提供ssh key的时候 ，认为入参无效
if [ ! -f ~/.ssh/id_rsa ] && ([ "$CONFIG_REPO" != "" ] || [ "$CODE_REPO" != "" ]) ; then
    echo "请提供相应的SSH Key来连接Git 服务器"
    exit
fi

#当不提供两个Repo的时候，默认为演示环境
demo="false"
if [ "$CONFIG_REPO" == "" ] && [ "$CODE_REPO" == "" ] ; then
    demo="true"
fi

#当不为演示环境的时候，必须提供出两个
if [ $demo = "false" ] && ([ "$CONFIG_REPO" == "" ] || [ "$CODE_REPO" == "" ]) ;then
    echo "非演示环境必须提供两个Git Repo"
    exit
fi


#初始化code
./code.sh $CODE_REPO $ASPECT_NAME;

#初始化Hybris Config，从Git或默认中读取
./config.sh $CONFIG_REPO $ASPECT_NAME;

#设置addon
echo "开始Addon的设置：$B2B_ADDONS $B2C_ADDONS"
cd /opt/aspects/${ASPECT_NAME}/hybris/conf && ./addons.sh


#阻塞直至等待端口打开
yWaitForPort.sh $WAIT_FOR


#jvm route   负载均衡使用
if [ "$JVM_ROUTE" == "dynamic" ]; then
	export JVM_ROUTE="$(yGenerateUUID.sh)"
	echo "Dynamic jvmRoute has been requested. Using: $JVM_ROUTE"
fi

#admin aspect  用来执行ant命令 第二个参数为命令  需要在宿主机执行 若Jenkins独立的话  如何
if [ "$ASPECT_NAME" == "admin" ]; then
	# we use cd because setantenv.sh uses `pwd` to export PLATFORM_HOME
	cd ${PLATFORM_HOME} && source setantenv.sh
	ant -Dde.hybris.platform.ant.production.skip.build=true -buildfile $PLATFORM_HOME "${@:2}"
else
    echo "开始进行Hybris设置"

    cd ${PLATFORM_HOME} && source setantenv.sh
    cat /opt/hybris/config/localextensions.xml
    ant clean all

    /opt/tomcat/bin/catalina.sh ${2:-run}
fi



