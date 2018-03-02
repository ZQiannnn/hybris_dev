FROM openjdk:8u151-jdk-slim

#作者
MAINTAINER ZQiannnn,<604922962@qq.com>

#执行命令 安装一些软件
RUN apt-get update && apt-get install -y --no-install-recommends curl openssh-client git gettext procps net-tools \
	&& rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini




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
COPY scripts /root/scripts
RUN mv /root/scripts/*.sh /usr/local/bin/
COPY updateRunningSystem.config /opt/hybris/updateRunningSystem.config


ENTRYPOINT ["/tini", "--"]
CMD ["init.sh"]