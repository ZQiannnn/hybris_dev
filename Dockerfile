#从精简JAVA镜像开始
FROM java:openjdk-8u111-alpine

#作者
MAINTAINER ZQiannnn,<604922962@qq.com>

#执行命令 安装一些软件
RUN apk add --update libstdc++ git openssh-client curl unzip bash ttf-dejavu coreutils tini && \
   rm -rf /etc/apk/keys/sgerrand.rsa.pub /tmp/* /var/cache/apk/*


#tomcat option部分
ENV CATALINA_SECURITY_OPTS=-Djava.security.egd=file:/dev/./urandom
ENV CATALINA_MEMORY_OPTS=-Xms2G\ -Xmx2G

ENV JAVA_OPTS=-Djava.awt.headless=true

#####################################################################################
#  Jenkins部分
#####################################################################################
ENV JENKINS_HOME /u01/jenkins/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

VOLUME /u01/jenkins/jenkins_home
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.46.3}
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

# jenkins.war checksum, download will be validated using it
ARG JENKINS_SHA=00424d3c851298b29376d1d09d7d3578a2bc4a03acf3914b317c47707cd5739a

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war


# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

ENV JENKINS_UC https://updates.jenkins.io


# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

#####################################################################################
#  Jenkins部分结束
#####################################################################################

#####################################################################################
#  Hybris部分开始
#####################################################################################
ENV HTTP_PORT=9001
ENV HTTPS_PORT=9002
ENV AJP_PORT=8009

#Tomcat版 SSL证书
ENV KEYSTORE_LOCATION=/u01/secrets/keystore
ENV KEYSTORE_PASSWORD=123456

#环境变量
ENV PLATFORM_HOME=/u01/hybris/bin/platform/

#Hybris版本 仅支持大版本
ENV HYBRIS_VERSION="6.3"
#下载好的binaries映射到容器 data持久化  jenkins数据及配置持久化
VOLUME ["/u01/hybris/binaries","/u01/hybris/data"]

#工具
ENV PATH="/u01/ytools:${PATH}"
#####################################################################################
#  Hybris部分结束
#####################################################################################



COPY binaries/ /u01/
COPY aspects /u01/aspects
COPY docker-entrypoint.sh /usr/local/bin/
COPY scripts /u01/scripts/


ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]
