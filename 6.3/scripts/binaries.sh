#!/usr/bin/env bash

#解压Hybris压缩包，并且清空相应的工程文件
set -e
rm -rf /opt/hybris/bin/custom
rm -rf /opt/hybris/config
rm -rf /opt/hybris/log
rm -rf /opt/hybris/roles
rm -rf /opt/cd hybris/temp
echo "\ntomcat.javaoptions=-noverify -agentpath:\"/opt/jrebel/lib/libjrebel64.so\" -Drebel.disable_update=true
tomcat.debugjavaoptions=-noverify -agentpath:\"/opt/jrebel/libjrebel64.so\" -Drebel.disable_update=true ">> /opt/hybris/bin/platform/project.propertie
