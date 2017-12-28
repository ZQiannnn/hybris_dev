#!/usr/bin/env bash
set -e

echo "StrictHostKeyChecking no">> /root/.ssh/config
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
    exec init.sh
fi
exec "$@"
