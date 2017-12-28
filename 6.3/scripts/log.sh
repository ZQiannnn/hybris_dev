#!/usr/bin/env bash
set -e
#查看日志
cd /opt/hybris/log/tomcat

tail -f console-$(date +%Y%m%d).log