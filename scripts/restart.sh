#!/usr/bin/env bash
set -e
source code.sh
source config.sh
cd ${PLATFORM_HOME} && ant clean all
