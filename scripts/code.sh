#!/usr/bin/env bash

set -e
#生成相应的工程

ASPECT_NAME=$1

cd ${PLATFORM_HOME} && source setantenv.sh

#生成完整的项目
ant modulegen -Dinput.module=accelerator -Dinput.name=hep -Dinput.package=com.hep

if [ "$ASPECT_NAME" == "b2b2c" ];then
    # b2b2c生成额外的工程
    ant extgen -Dinput.template=yacceleratorstorefront -Dinput.name=hepb2bstorefront -Dinput.package=com.hep.b2b
    mv /u01/hybris/bin/custom/hepb2bstorefront /u01/hybris/bin/custom/hep
fi

#生成gitignore文件
cd /u01/hybris/bin/custom/hep
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