#!/bin/bash
#===============================================
# File name: init-settings.sh
# Description: This script will be executed during the first boot
# Author: SuLingGG
# Blog: https://mlapp.cn
#===============================================

# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

# Disable IPV6 ula prefix
# sed -i 's/^[^#].*option ula/#&/' /etc/config/network

#Add eth1-4 as Lan port
#sed -i 's/list ports \'eth0\'/list ports \'eth1\'/g' /etc/config/network

# Check file system during boot
# uci set fstab.@global[0].check_fs=1
# uci commit fstab

#Set Turboacc
uci set turboacc.config.tcpcca='bbr'
uci set turboacc.config.fullcone='2'
uci set turboacc.config.fastpath_fo_hw='1'
uci commit turboacc
/etc/init.d/turboacc restart

exit 0
