#!/bin/bash
set -e


#先定义函数
function initCode(){

     if [ ! -d /opt/hybris/bin/custom/hep ]; then
        #如果工程不存在
        echo "初始化Code：$CODE_REPO"

        cd ${PLATFORM_HOME} && source setantenv.sh

        #生成完整的项目
        ant modulegen -Dinput.module=accelerator -Dinput.name=hep -Dinput.package=com.hep

        if [ "$ASPECT_NAME" == "b2b2c" ];then
            # b2b2c生成额外的工程
            ant extgen -Dinput.template=yacceleratorstorefront -Dinput.name=hepb2bstorefront -Dinput.package=com.hep.b2b
            mv /opt/hybris/bin/custom/hepb2bstorefront /opt/hybris/bin/custom/hep
        fi



        if [ "$1" == "false" ] ;then
            #不为演示环境的时候提交到git上
            cd /opt/hybris/bin/custom/hep
            touch .gitignore
            echo ".*
.*/
*.build.number
*.class

*-testclasses.xml
build.xml
external-dependencies.xml
platformhome.properties
*.xsd
ruleset.xml

/hepstorefront/resources/hepstorefront
/hepb2bstorefront/resources/hepb2bstorefront
/hepb2bstorefront/web/testclasses
/hepstorefront/web/testclasses

**/classes/
**/testclasses/
**/gensrc/
**/addonsrc/
**/commonwebsrc/
**/addons/

**/build/
**/eclipsebin/

**/jalo/

/hepbackoffice/resources/backoffice/hepbackoffice_bof.jar

/hepstorefront/web/webroot/cmscockpit

/hepstorefront/web/webroot/cockpit

wro_addon.xml

production.css.gz
production.css
production.js" >> .gitignore
            git init
            git add .
            git commit -m "first commit"
            git remote add origin $CODE_REPO
            git push -u origin master
            echo "成功推送 CodeRepo ：$CODE_REPO 成功"
        fi
        #mkdir /opt/hybris/custom
     else
        #工程存在
        if [ "$1" == "false" ] ;then
            #不为演示环境时更新工程
            cd /opt/hybris/bin/custom/hep && git pull
        fi
     fi

}


function initConfig(){
    echo "初始化Config：$CONFIG_REPO"
    if [ "$CONFIG_REPO" != "" ];then
      #提供了config repo的时候，从git上拉下来 或者传到git上
      echo "Pull Config From Git :$CONFIG_REPO "
      if [ ! -d /opt/config ]; then
            #当/opt/config不存在的时候  两种情况：1.从未clone   2.git 仓库未初始化
            #克隆至临时目录
            git clone -b develop  $CONFIG_REPO "/opt/config"
            if [ "$?" -ne "0" ];then
                echo "开始准备初始化远程config仓库"
                #git仓库未初始化
                mkdir /opt/config
                cp /opt/aspects/${ASPECT_NAME}/hybris/conf/local.properties /opt/config
                cp /opt/aspects/${ASPECT_NAME}/hybris/conf/localextensions.xml /opt/config
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
        #此时为演示环境，将标准的localextension.xml和local.properties拷贝到/opt/config
        echo "使用自带的config文件"
        mkdir /opt/config
        cp /opt/aspects/${ASPECT_NAME}/hybris/conf/local.properties /opt/config
        cp /opt/aspects/${ASPECT_NAME}/hybris/conf/localextensions.xml /opt/config

    fi
}



function initAddons(){
    echo "开始Addon的设置：$B2B_ADDONS $B2C_ADDONS"
    cd /opt/aspects/${ASPECT_NAME}/hybris/conf && ./addons.sh
}

#设置tomcat运行参数
export CATALINA_OPTS="-DPLATFORM_HOME=$PLATFORM_HOME $CATALINA_SECURITY_OPTS $CATALINA_MEMORY_OPTS -Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=de.hybris.tomcat.EnvPropertySource $ADDITIONAL_CATALINA_OPTS"
#设置切面，没有的话用default
export ASPECT_NAME=${1:-b2c}

#设置tomcat工作目录  只启动一个tomcat实例
export CATALINA_BASE="/opt/aspects/tomcat"

#以aspect来控制hybris的conf
#export HYBRIS_OPT_CONFIG_DIR="/opt/aspects/$ASPECT_NAME/hybris/conf"

cat ~/.ssh/id_rsa


 #当提供了任意一个repo ，却没有提供ssh key的时候 ，认为入参无效
if [ ! -f ~/.ssh/id_rsa ] && ([ "$CONFIG_REPO" != "" ] || [ "$CODE_REPO" != "" ]) ; then
    echo "请提供相应的SSH Key来连接Git 服务器"
    exit
fi

#当不提供两个Repo的时候，默认为演示环境
demo="false"
if [ "$CONFIG_REPO" == "" ] && [ "$CODE_REPO" == "" ] ; then
    demo="true"
fi
echo $demo

#当不为演示环境的时候，必须提供出两个
if [ $demo = "false" ] && ([ "$CONFIG_REPO" == "" ] || [ "$CODE_REPO" == "" ]) ;then
    echo "非演示环境必须提供两个Git Repo"
    exit
fi


#初始化code
initCode $demo;

#初始化Hybris Config，从Git或默认中读取
initConfig

#设置addon
initAddons $demo;


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
    echo "开始进行Hybris设置"
    #将git clone下来的config复制到hybris底下
    cp /opt/config/local.properties /opt/hybris/config/local.properties
    cp /opt/config/localextensions.xml /opt/hybris/config/localextensions.xml

    cd ${PLATFORM_HOME} && source setantenv.sh
    ant clean all
    #如果没有初始化则进行初始化
    if [ ! -d /opt/hybris/data/hsqldb ]; then
        ant initialize -Dtenant=master
    fi
    /opt/tomcat/bin/catalina.sh ${2:-run}
fi



