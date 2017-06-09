#!/usr/bin/env bash
set -e

function generateCode(){
            echo "初始化Code：$CODE_REPO"

            cd ${PLATFORM_HOME} && source setantenv.sh

            #生成完整的项目
            ant modulegen -Dinput.module=accelerator -Dinput.name=hep -Dinput.package=com.hep

            if [ "$1" == "b2b2c" ];then
                # b2b2c生成额外的工程
                ant extgen -Dinput.template=yacceleratorstorefront -Dinput.name=hepb2bstorefront -Dinput.package=com.hep.b2b
                mv /opt/hybris/bin/custom/hepb2bstorefront /opt/hybris/bin/custom/hep
            fi
}
#初始化code用
    CODE_REPO=$1
    ASPECT_NAME=$2
    if [ $CODE_REPO != "" ]; then
        if [ ! -d /opt/hybris/bin/custom/hep ]; then

        #先clone develop分支
        git clone -b develop $CODE_REPO

        if [ "$?" == "0" ]; then
               echo "Clone Develop 分支成功"
        else
             #如果工程不存在
            generateCode $ASPECT_NAME;
            #不为演示环境的时候提交到git上
            cd /opt/hybris/bin/custom/hep
            touch .gitignore
            echo ".*
\!.gitignore
.*/
*.build.number
*.class

*-testclasses.xml
build.xml
external-dependencies.xml
platformhome.properties
*.xsd
ruleset.xml

**/classes/
**/testclasses/
**/gensrc/
**/addonsrc/
**/commonwebsrc/
**/addons/
**/build/
**/eclipsebin/

**/jalo/
\!/assistedservicestorefront/src/de/hybris/platform/cms2/jalo/

/hepstorefront/resources/hepstorefront
/hepb2bstorefront/resources/hepb2bstorefront
/hepb2bstorefront/web/testclasses
/hepstorefront/web/testclasses
/hepbackoffice/resources/backoffice/hepbackoffice_bof.jar
/hepstorefront/web/webroot/cmscockpit
/hepstorefront/web/webroot/cockpit
**/wro_addons.xml" >> .gitignore
            git init
            git add .
            git commit -m "first commit"
            git remote add origin $CODE_REPO
            git push -u origin master
            echo "成功推送 CodeRepo ：$CODE_REPO 成功"
        fi


        #mkdir /opt/hybris/custom
     else
        #工程存在  更新工程
        cd /opt/hybris/bin/custom/hep && git pull
     fi
    else
       generateCode $ASPECT_NAME;
    fi

