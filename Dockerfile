FROM openjdk:8u151-jdk-slim

#作者
MAINTAINER ZQiannnn,<604922962@qq.com>

#执行命令 安装一些软件
RUN apt-get update && apt-get install -y --no-install-recommends curl openssh-client git gettext procps net-tools \
	&& rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION 0.14.0
ENV TINI_SHA 6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd

# Use tini as subreaper in Docker container to adopt zombie processes
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c -



#####################################################################################
#  Hybris部分开始
#####################################################################################
EXPOSE 9001
EXPOSE 9002
EXPOSE 8983

#环境变量
ENV PLATFORM_HOME=/opt/hybris/bin/platform/

ENV PATH $PLATFORM_HOME/apache-ant-1.9.1/bin:$PATH

#下载好的binaries映射到容器 data持久化  jenkins数据及配置持久化
VOLUME ["/u01/packages/binaries","/opt/hybris/data","/root/.ssh"]


#####################################################################################
#  Hybris部分结束
#####################################################################################
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY scripts /root/scripts
RUN mv /root/scripts/*.sh /usr/local/bin/
COPY updateRunningSystem.config /opt/hybris/updateRunningSystem.config


ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]