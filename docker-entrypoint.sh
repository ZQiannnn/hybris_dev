#!/usr/bin/env bash

#设置tomcat运行参数
export CATALINA_OPTS="-DPLATFORM_HOME=$PLATFORM_HOME $CATALINA_SECURITY_OPTS $CATALINA_MEMORY_OPTS -Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=de.hybris.tomcat.EnvPropertySource $ADDITIONAL_CATALINA_OPTS"

source /u01/scripts/jenkins/jenkins.sh

