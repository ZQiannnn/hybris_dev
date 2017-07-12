#!/usr/bin/env bash
set -e

ASPECT_NAME=$1
cd ${PLATFORM_HOME}

./hybrisserver.sh stop
./hybrisserver.sh start