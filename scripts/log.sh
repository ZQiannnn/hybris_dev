#!/usr/bin/env bash
set -e

cd /u01/hybris/log/tomcat

tail -f console-$(date +%Y%m%d).log