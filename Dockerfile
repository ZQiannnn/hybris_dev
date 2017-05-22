#从精简JAVA镜像开始
FROM marcielmj/java-8-alpine

#坐着
MAINTAINER ZQiannnn,<604922962@qq.com>

#执行命令 安装一些软件
RUN apk add --update libstdc++ openssh git && \
   rm -rf /etc/apk/keys/sgerrand.rsa.pub /tmp/* /var/cache/apk/*

#安装一些软件 git
#RUN

#复制文件到镜像内
#拷贝Hybris源代码

#RUN mkdir /opt/hybris/

ADD binaries/ /opt/


#考虑到镜像的大小以及code的持久，把bin放到容器外部
VOLUME ["/opt/hybris/bin/custom"]
#VOLUME ["/opt/hybris/config"]

ADD aspects /opt/aspects

#拷贝执行脚本
ADD startup.sh /opt/startup/

#添加脚本的可运行权限
RUN chmod +x /opt/startup/startup.sh && \
   chmod +x /opt/tomcat/bin/catalina.sh && \
   chmod +x /opt/ytools/*.sh  && \
   chmod +x /opt/aspects/b2b/hybris/conf/addons.sh  && \
   chmod +x /opt/aspects/b2b2c/hybris/conf/addons.sh  && \
   chmod +x /opt/aspects/b2c/hybris/conf/addons.sh


#环境变量开始

#tomcat option部分
ENV CATALINA_SECURITY_OPTS=-Djava.security.egd=file:/dev/./urandom
ENV CATALINA_MEMORY_OPTS=-Xms2G\ -Xmx2G

#端口部分
ENV HTTP_PORT=9001
ENV HTTPS_PORT=9002
ENV AJP_PORT=8009

#SSL证书
ENV KEYSTORE_LOCATION=/etc/ssl/certs/hybris/keystore
ENV KEYSTORE_PASSWORD=123456

#内部环境变量
ENV PLATFORM_HOME=/opt/hybris/bin/platform/

#工具
ENV WAIT_FOR=""
ENV JVM_ROUTE=""
ENV PATH="/opt/ytools:${PATH}"

#Git部分
VOLUME ["/root/.ssh"]
ENV CONFIG_REPO=""
ENV CODE_REPO=""

#addon部分
ENV B2B_ADDONS=[]
ENV B2C_ADDONS=[]


ENTRYPOINT ["/opt/startup/startup.sh"]
