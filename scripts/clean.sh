#!/usr/bin/env bash
set -e

ASPECT_NAME=$1
cd ${PLATFORM_HOME} && source setantenv.sh

ant clean all
