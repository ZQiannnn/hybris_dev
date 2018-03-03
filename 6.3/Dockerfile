FROM openjdk:8u151-jdk-slim

#作者
MAINTAINER ZQiannnn,<604922962@qq.com>

#执行命令 安装一些软件
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
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

COPY hybris/bin/ext-accelerator /opt/hybris/bin/ext-accelerator
COPY hybris/bin/ext-addon /opt/hybris/bin/ext-addon
COPY hybris/bin/ext-atdd /opt/hybris/bin/ext-atdd
COPY hybris/bin/ext-atddtests /opt/hybris/bin/ext-atddtests
COPY hybris/bin/ext-backoffice /opt/hybris/bin/ext-backoffice
COPY hybris/bin/ext-channel /opt/hybris/bin/ext-channel
COPY hybris/bin/ext-cockpit /opt/hybris/bin/ext-cockpit
COPY hybris/bin/ext-commerce /opt/hybris/bin/ext-commerce
COPY hybris/bin/ext-content /opt/hybris/bin/ext-content
COPY hybris/bin/ext-customer-experience /opt/hybris/bin/ext-customer-experience
COPY hybris/bin/ext-data /opt/hybris/bin/ext-data
COPY hybris/bin/ext-eventtracking /opt/hybris/bin/ext-eventtracking
COPY hybris/bin/ext-integration /opt/hybris/bin/ext-integration
COPY hybris/bin/ext-platform-backoffice /opt/hybris/bin/ext-platform-backoffice
COPY hybris/bin/ext-platform-optional /opt/hybris/bin/ext-platform-optional
COPY hybris/bin/ext-print /opt/hybris/bin/ext-print
COPY hybris/bin/ext-supportability /opt/hybris/bin/ext-supportability
COPY hybris/bin/ext-template /opt/hybris/bin/ext-template
COPY hybris/bin/platform /opt/hybris/bin/platform
COPY jrebel /opt/jrebel

#环境变量
ENV PLATFORM_HOME=/opt/hybris/bin/platform/

ENV PATH $PLATFORM_HOME/apache-ant-1.9.1/bin:$PATH

#下载好的binaries映射到容器 data持久化  jenkins数据及配置持久化
VOLUME ["/opt/hybris/data","/root/.ssh"]


#####################################################################################
#  Hybris部分结束
#####################################################################################
COPY scripts /root/scripts
COPY jgroups/jgroups-tcp.xml /opt/hybris/bin/platform/ext/core/resources/jgroups-tcp.xml
COPY jgroups/jgroups-udp.xml /opt/hybris/bin/platform/ext/core/resources/jgroups-udp.xml
RUN mv /root/scripts/*.sh /usr/local/bin/
COPY updateRunningSystem.config /opt/hybris/updateRunningSystem.config


ENTRYPOINT ["/tini", "--"]
CMD ["init-tcp.sh"]