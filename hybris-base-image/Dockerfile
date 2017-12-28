#从精简JAVA镜像开始
FROM openjdk:8-jdk-slim

#作者
MAINTAINER Stefan Lehmann <stefan.lehmann@unic.com>

LABEL Fork=stefanleh/hybris-base-image

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
# hybris needs unzip and lsof for the solr server setup
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates net-tools curl unzip lsof wget gpg dirmngr gettext procps\
    && apt-get autoclean && apt-get --purge -y autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10
RUN set -ex; \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
	chmod +x /usr/local/bin/gosu; \
# verify that the binary works
	gosu nobody true; \
	\
	apt-get purge -y --auto-remove $fetchDeps

# set the PLATFORM_HOME environment variable used by hybris
ENV PLATFORM_HOME=/home/hybris/bin/platform/
ENV PATH=$PLATFORM_HOME:$PATH

# add hybris user
RUN useradd -d /home/hybris -u 1000 -m -s /bin/bash hybris

# define hybris home dir as volume
VOLUME /home/hybris/data

# expose hybris ports
EXPOSE 9001
EXPOSE 9002

# expose default solr port
EXPOSE 8983

# expose the default debug port for connecting via IDE
EXPOSE 8000

# copy the entrypoint script over
COPY entrypoint.sh /entrypoint.sh

# copy the update system config to image
COPY updateRunningSystem.config /home/hybris/updateRunningSystem.config

WORKDIR /home/hybris

# set entrypoint of container
ENTRYPOINT ["/entrypoint.sh"]

CMD ["run"]
