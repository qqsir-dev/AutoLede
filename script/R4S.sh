#!/bin/bash

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add luci-app-unblockneteasemusic
# rm -rf ../../feeds/luci/applications/luci-app-unblockmusic
# git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git

# Add luci-theme-argon
rm -rf ../../feeds/luci/themes/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ./luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/pics/bg1.jpg luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
popd

# Modify default IP
sed -i 's/192.168.1.1/192.168.50.1/g' package/base-files/files/bin/config_generate
sed -i '/uci commit system/i\uci set system.@system[0].hostname='TimWrt'' package/lean/default-settings/files/zzz-default-settings
sed -i "s/OpenWrt /YG @ TimWrt /g" package/lean/default-settings/files/zzz-default-settings
 
# Test kernel 6.0
# sed -i 's/5.15/6.0/g' target/linux/rockchip/Makefile

# Set Default Language - English
sed -i "/exit/ised -i \"s/'zh_cn'/'en'/g\" /etc/config/luci\n" package/base-files/files/etc/rc.local

# Modify ShadowSocksR Plus+ Menu order
find package/*/ feeds/*/ -maxdepth 6 -path "*helloworld/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua" | xargs -i sed -i 's/\"ShadowSocksR Plus+\")\, 10/\"ShadowSocksR Plus+\")\, 0/g' {}

# Add zhipin.com to ssr white list
sed -i '$a\zhipin.com\nmacenjoy.co' feeds/helloworld/luci-app-ssr-plus/root/etc/ssrplus/white.list

# Custom configs
# git am $GITHUB_WORKSPACE/patches/lean/*.patch
# git am $GITHUB_WORKSPACE/patches/*.patch
echo -e " qqsir's TimWrt built on "$(date +%Y.%m.%d)"\n -----------------------------------------------------" >> package/base-files/files/etc/banner
echo 'net.bridge.bridge-nf-call-iptables=0' >> package/base-files/files/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-ip6tables=0' >> package/base-files/files/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-arptables=0' >> package/base-files/files/etc/sysctl.conf
echo 'net.bridge.bridge-nf-filter-vlan-tagged=0' >> package/base-files/files/etc/sysctl.conf
