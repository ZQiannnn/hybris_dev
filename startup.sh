#!/bin/bash
set -e
#设置tomcat运行参数
export CATALINA_OPTS="-DPLATFORM_HOME=$PLATFORM_HOME $CATALINA_SECURITY_OPTS $CATALINA_MEMORY_OPTS -Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=de.hybris.tomcat.EnvPropertySource $ADDITIONAL_CATALINA_OPTS"
#设置切面，没有的话用default
export ASPECT_NAME=${1:-default}

#设置tomcat工作目录  只启动一个tomcat实例
export CATALINA_BASE="/opt/aspects/tomcat"

#以aspect来控制hybris的conf
export HYBRIS_OPT_CONFIG_DIR="/opt/aspects/$ASPECT_NAME/hybris/conf"

#等待端口打开
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
    cd ${PLATFORM_HOME} && source setantenv.sh
    ant clean all
	/opt/tomcat/bin/catalina.sh ${2:-run}
fi
