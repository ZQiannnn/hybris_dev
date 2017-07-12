#!/usr/bin/env bash
set -e

cd ${PLATFORM_HOME}

./hybrisserver.sh stop
./hybrisserver.sh start