#!/bin/bash
cd $PLATFORM_HOME && source setantenv.sh


ant addoninstall -Daddonnames="liveeditaddon,chineseprofileaddon,chineselogisticaddon,chinesepaymentaddon,chinesetaxinvoiceaddon,chinesepspalipaymockaddon,commerceorgsamplesaddon,chinesestoreaddon,verticalnavigationaddon,promotionenginesamplesaddon,chineseaddressaddon,chinesepspwechatpaymentaddon,consignmenttrackingaddon,consignmenttrackingmockaddon,notificationaddon,customerinterestsaddon,stocknotificationaddon,chineseproductsharingaddon,customerticketingaddon" -DaddonStorefront.yacceleratorstorefront="hepstorefront"


