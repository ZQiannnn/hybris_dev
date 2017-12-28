#!/usr/bin/env bash

source code.sh
source config.sh
cd ${PLATFORM_HOME} && ant clean all
