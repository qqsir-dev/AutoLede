#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

#!/bin/bash

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add luci-app-passwall
git clone https://github.com/xiaorouji/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2
svn export https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall

# Add luci-theme-argon
rm -rf ../../feeds/luci/themes/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
# git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ./luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/pics/bg1.jpg luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash
# svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd luci-app-openclash/tools/po2lmo
make && sudo make install
pushd -0
dirs -v

# 更改默认 Shell 为 zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by Y.G/g" package/lean/default-settings/files/zzz-default-settings

# Set BIOS Boot Partition to 1 MiB
sed -i 's/256/1024/g' target/linux/x86/image/Makefile

# Update ipt2socks hash
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=5279eb1cb7555cf9292423cc9f672dc43e6e214b3411a6df26a6a1cfa59d88b7/g' feeds/helloworld/ipt2socks/Makefile

# Modify default IP
# sed -i 's/192.168.1.1/192.168.50.2/g' package/base-files/files/bin/config_generate

# Test kernel 6.1
sed -i 's/5.15/6.1/g' target/linux/x86/Makefile

# Network Configuration
sed -i "/exit/iuci set network.wan.ifname=\'eth2\'\nuci set network.wan.proto=\'pppoe\'\nuci set network.wan.username=\'990001257663\'\nuci set network.wan.password=\'u6s3x4r8\'\nuci set network.lan.netmask=\'255.255.255.0\'\nuci set network.lan.dns=\'114.114.114.114 119.29.29.29 223.5.5.5\'\nuci set network.lan.ip6assign=\'64\'\nuci set network.lan.ifname=\'eth0 eth1 eth3\'\nuci set network.wan6.ifname=\'@wan\'\nuci commit network\nuci set dhcp.lan.ignore=\'0\'\nuci set dhcp.lan.start=\'150\'\nuci set dhcp.lan.limit=\'100\'\nuci set dhcp.lan.ra_management=\'1\'\nuci add_list dhcp.lan.dhcp_option=\'6,114.114.114.114,119.29.29.29\'\nuci set dhcp.lan.force=\'1\'\nuci set dhcp.lan.ra=\'hybrid\'\nuci set dhcp.lan.ra_default=\'1\'\nuci set dhcp.lan.dhcpv6=\'relay\'\nuci set dhcp.lan.ndp=\'relay\'\nuci add dhcp host\nuci commit dhcp\n" package/lean/default-settings/files/zzz-default-settings

# CHG Netdata support SSL (with hook-feeds.sh)
sed -i 's/http/https/g' package/feeds/luci/luci-app-netdata/luasrc/view/netdata/netdata.htm

# uhttpd cert
sed -i 's/uhttpd.crt/uhttpd.pem/g' package/network/services/uhttpd/files/uhttpd.config

# turn on turboacc bbr_cca
# sed -i $'s/option bbr_cca \'0\'/option bbr_cca \'1\'/g' feeds/luci/applications/luci-app-turboacc/root/etc/config/turboacc
# sed -i $'s/option sfe_flow \'1\'/option sfe_flow \'0\'/g' feeds/luci/applications/luci-app-turboacc/root/etc/config/turboacc

# Set Default Language - English
sed -i "/exit/ised -i \"s/'zh_cn'/'en'/g\" /etc/config/luci\n" package/base-files/files/etc/rc.local

# Set Nginx client_max_body_size 2048M
# sed -i 's/128M/2048M/g' /etc/nginx/uci.conf

# Modify ShadowSocksR Plus+ Menu order
find package/*/ feeds/*/ -maxdepth 6 -path "*helloworld/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua" | xargs -i sed -i 's/\"ShadowSocksR Plus+\")\, 10/\"ShadowSocksR Plus+\")\, 0/g' {}

# 在线用户
svn export https://github.com/haiibo/packages/trunk/luci-app-onliner package/luci-app-onliner
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh
