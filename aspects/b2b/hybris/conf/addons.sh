#!/bin/bash
cd $PLATFORM_HOME && source setantenv.sh

ant addoninstall -Daddonnames="chineseaddressaddon,chinesecommerceorgaddressaddon,b2bacceleratoraddon,commerceorgaddon,promotionenginesamplesaddon,chinesestoreaddon,commerceorgsamplesaddon,customerticketingaddon" -DaddonStorefront.yacceleratorstorefront="hepstorefront"
