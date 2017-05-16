#从精简JAVA镜像开始
FROM marcielmj/java-8-alpine

#坐着
MAINTAINER ZQiannnn,<604922962@qq.com>

#执行命令
RUN apk add --update libstdc++ && \
    rm -rf /etc/apk/keys/sgerrand.rsa.pub /tmp/* /var/cache/apk/*

#安装一些软件 git
#RUN

#复制文件到镜像内
#拷贝Hybris源代码
ADD binaries/ /opt/

ADD aspects /opt/aspects

#拷贝执行脚本
ADD startup.sh /opt/startup/

#添加脚本的可运行权限
RUN chmod +x /opt/startup/startup.sh && \
    chmod +x /opt/tomcat/bin/catalina.sh && \
    chmod +x /opt/ytools/*.sh


#环境变量开始

ENV CATALINA_SECURITY_OPTS=-Djava.security.egd=file:/dev/./urandom
ENV CATALINA_MEMORY_OPTS=-Xms2G\ -Xmx2G
ENV HTTP_PORT=9001
ENV HTTPS_PORT=9002
ENV AJP_PORT=8009
ENV KEYSTORE_LOCATION=/etc/ssl/certs/hybris/keystore
ENV KEYSTORE_PASSWORD=123456
ENV PLATFORM_HOME=/opt/hybris/bin/platform/
ENV WAIT_FOR=""
ENV JVM_ROUTE=""
ENV PATH="/opt/ytools:${PATH}"


ENTRYPOINT ["/opt/startup/startup.sh"]
