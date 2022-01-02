#!/bin/bash

# fix netdata
rm -rf ./feeds/packages/admin/netdata
svn co https://github.com/DHDAXCW/packages/branches/ok/admin/netdata ./feeds/packages/admin/netdata

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add luci-app-ssr-plus
git clone --depth=1 https://github.com/fw876/helloworld.git

# Add luci-app-unblockneteasemusic
rm -rf ../lean/luci-app-unblockmusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git

# Add luci-app-vssr <M>
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr

# Add luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ../lean/luci-theme-argon

# Add jd-dailybonus
rm -rf ../lean/luci-app-jd-dailybonus
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git
popd

# 动态DNS
git clone --depth 1 https://github.com/small-5/ddns-scripts-dnspod package/lean/ddns-scripts_dnspod
git clone --depth 1 https://github.com/small-5/ddns-scripts-aliyun package/lean/ddns-scripts_aliyun
svn co https://github.com/QiuSimons/OpenWrt_luci-app/trunk/luci-app-tencentddns package/lean/luci-app-tencentddns
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-aliddns feeds/luci/applications/luci-app-aliddns
ln -sf ../../../feeds/luci/applications/luci-app-aliddns ./package/feeds/luci/luci-app-aliddns

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
sed -i '/18.06/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version=$(date -d "$(rdate -p ntp.aliyun.com)" +'%Y-%m-%d')
sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
popd

# Modify default IP
sed -i 's/192.168.1.1/192.168.50.2/g' package/base-files/files/bin/config_generate
sed -i '/uci commit system/i\uci set system.@system[0].hostname='TimWrt'' package/lean/default-settings/files/zzz-default-settings
sed -i "s/OpenWrt /YG @ TimWrt $(TZ=UTC-8 date "+%Y%m%d") /g" package/lean/default-settings/files/zzz-default-settings
# find package/*/ feeds/*/ -maxdepth 6 -path "*luci-app-smartdns/luasrc/controller/smartdns.lua" | xargs -i sed -i 's/\"SmartDNS\")\, 4/\"SmartDNS\")\, 3/g' {} 
# Test kernel 5.15
# sed -i 's/5.10/5.15/g' target/linux/x86/Makefile

# Network Configuration
sed -i "/exit/iuci set network.lan.gateway=\'192.168.50.1\'\nuci set network.lan.dns=\'119.29.29.29 223.5.5.5\'\nuci commit network\nuci set dhcp.lan.ignore=\'1\'\nuci set dhcp.lan.dhcpv6=\'disabled\'\nuci commit dhcp\n" package/lean/default-settings/files/zzz-default-settings
        
# nlbwmon netlink uffer size
# sed -i '1s/$/&\nnet.core.wmem_max=16777216\nnet.core.rmem_max=16777216/' package/base-files/files/etc/sysctl.conf
# sed -i "/exit/iuci set nlbwmon.@nlbwmon[0].netlink_buffer_size=\'10485760\'\nuci set nlbwmon.@nlbwmon[0].commit_interval=\'2h\'\nuci commit nlbwmon\n" package/lean/default-settings/files/zzz-default-settings
        
# Set Default Language - English
sed -i "/exit/ised -i \"s/'zh_cn'/'en'/g\" /etc/config/luci\n" package/base-files/files/etc/rc.local

# Custom configs
# git am $GITHUB_WORKSPACE/patches/lean/*.patch
# git am $GITHUB_WORKSPACE/patches/*.patch
echo -e " qqsir's TimWrt built on "$(date +%Y.%m.%d)"\n -----------------------------------------------------" >> package/base-files/files/etc/banner
echo 'net.bridge.bridge-nf-call-iptables=0' >> package/base-files/files/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-ip6tables=0' >> package/base-files/files/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-arptables=0' >> package/base-files/files/etc/sysctl.conf
echo 'net.bridge.bridge-nf-filter-vlan-tagged=0' >> package/base-files/files/etc/sysctl.conf
