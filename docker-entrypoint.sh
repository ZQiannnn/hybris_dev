#!/usr/bin/env bash

#设置tomcat运行参数
export CATALINA_OPTS="-DPLATFORM_HOME=$PLATFORM_HOME $CATALINA_SECURITY_OPTS $CATALINA_MEMORY_OPTS -Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=de.hybris.tomcat.EnvPropertySource $ADDITIONAL_CATALINA_OPTS"

#设置tomcat工作目录  只启动一个tomcat实例
export CATALINA_BASE="/u01/aspects/tomcat"

export JVM_ROUTE="$(yGenerateUUID.sh)"
echo "Dynamic jvmRoute has been requested. Using: $JVM_ROUTE"

source /u01/scripts/jenkins/jenkins.sh

