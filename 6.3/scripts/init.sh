source binaries.sh
source code.sh
source config.sh

export DOCKER_CONTAINER_IP=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
echo "
cluster.broadcast.method.jgroups.tcp.bind_addr=$DOCKER_CONTAINER_IP" >> /opt/hybris/config/local.properties

source clean.sh

if [ "$HYBRIS_INITIALIZE_SYSTEM" = "yes" ]; then
    ant initialize -Dde.hybris.platform.ant.production.skip.build=true
fi
if [ "$HYBRIS_UPDATE_SYSTEM" = "yes" ]; then
    ant updatesystem -DconfigFile=/opt/hybris/updateRunningSystem.config
fi

source start.sh