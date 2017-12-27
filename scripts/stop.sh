#!/usr/bin/env bash
set -e
#停止hybris服务
cd ${PLATFORM_HOME} && ./hybrisserver.sh stop
