#!/usr/bin/env bash
set -e

source binaries.sh
source code.sh
source config.sh

sed -i 's/clustermode=false/clustermode=true/g' /opt/hybris/bin/platform/project.properties
sed -i 's/cluster.nodes.autodiscovery=false/cluster.nodes.autodiscovery=true/g' /opt/hybris/bin/platform/project.properties
#sed -i 's/cluster.broadcast.method.jgroups.configuration=jgroups-udp.xml/cluster.broadcast.method.jgroups.configuration=jgroups-udp.xml/g' /opt/hybris/bin/platform/project.properties

source clean.sh

if [ "$HYBRIS_INITIALIZE_SYSTEM" = "yes" ]; then
    ant initialize -Dde.hybris.platform.ant.production.skip.build=true
fi
if [ "$HYBRIS_UPDATE_SYSTEM" = "yes" ]; then
    ant updatesystem -DconfigFile=/opt/hybris/updateRunningSystem.config
fi

source start.sh