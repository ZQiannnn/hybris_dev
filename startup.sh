#!/bin/bash
set -e
#设置tomcat运行参数
export CATALINA_OPTS="-DPLATFORM_HOME=$PLATFORM_HOME $CATALINA_SECURITY_OPTS $CATALINA_MEMORY_OPTS -Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=de.hybris.tomcat.EnvPropertySource $ADDITIONAL_CATALINA_OPTS"
#设置切面，没有的话用default
export ASPECT_NAME=${1:-b2c}

#设置tomcat工作目录  只启动一个tomcat实例
export CATALINA_BASE="/opt/aspects/tomcat"

#以aspect来控制hybris的conf
#export HYBRIS_OPT_CONFIG_DIR="/opt/aspects/$ASPECT_NAME/hybris/conf"
ping www.baidu.com

#改成通过git控制conf和extension

if [ "$CONFIG_REPO" != "" ];then
      #提供了config repo的时候，从git上拉下来 或者传到git上
      echo "Pull Config From Git :$CONFIG_REPO "
      if [ ! -d "/opt/config" ]; then
            #当/opt/config不存在的时候  两种情况：1.从未clone   2.git 仓库未初始化
            git clone -b develop $CONFIG_REPO "/opt/config"
            if [ "$?" -ne "0" ];then
                echo "开始准备初始化远程config仓库"
                #git仓库未初始化
                mkdir /opt/config
                cp /opt/aspects/${ASPECT_NAME}/hybris/conf/local.properties /opt/config
                cp /opt/hybris/config/localextension.xml /opt/config
                cd /opt/config
                git init
                git add .
                git commit -m "first commit"
                git remote add origin $CONFIG_REPO
                git push -u origin develop
                echo "成功推送 ConfigRepo ：$CONFIG_REPO 成功"
            else
                #克隆成功
                echo "克隆ConfigRepo ：$CONFIG_REPO 成功"
            fi
      else
            echo "更新config"
            cd /opt/config
            git pull
      fi
else
    #没有提供CONFIG_REPO的时候直接用自带的配置文件
    echo "使用自带的config文件"
    export HYBRIS_OPT_CONFIG_DIR="/opt/aspects/$ASPECT_NAME/hybris/conf"
fi

#阻塞直至等待端口打开
yWaitForPort.sh $WAIT_FOR


#jvm route   负载均衡使用
if [ "$JVM_ROUTE" == "dynamic" ]; then
	export JVM_ROUTE="$(yGenerateUUID.sh)"
	echo "Dynamic jvmRoute has been requested. Using: $JVM_ROUTE"
fi

#admin aspect  用来执行ant命令 第二个参数为命令  需要在宿主机执行 若Jenkins独立的话  如何
if [ "$ASPECT_NAME" == "admin" ]; then
	# we use cd because setantenv.sh uses `pwd` to export PLATFORM_HOME
	cd ${PLATFORM_HOME} && source setantenv.sh
	ant -Dde.hybris.platform.ant.production.skip.build=true -buildfile $PLATFORM_HOME "${@:2}"
else
    #将git clone下来的config复制到hybris底下
    cp /opt/config/local.properties /opt/hybris/config
    cp /opt/config/localextension.xml /opt/hybris/config

    cd ${PLATFORM_HOME} && source setantenv.sh
   # ant clean all
   # /opt/tomcat/bin/catalina.sh ${2:-run}
fi
