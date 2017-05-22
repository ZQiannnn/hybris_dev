#!/bin/bash
cd $PLATFORM_HOME && source setantenv.sh

ant addoninstall -Daddonnames="commerceorgsamplesaddon,assistedservicestorefront,customerticketingaddon,promotionenginesamplesaddon,textfieldconfiguratortemplateaddon,orderselfserviceaddon,liveeditaddon,smarteditaddon" -DaddonStorefront.yacceleratorstorefront="hepstorefront,hepb2bstorefront"

ant addoninstall -Daddonnames="b2bacceleratoraddon,commerceorgaddon" -DaddonStorefront.yacceleratorstorefront="hepb2bstorefront"


