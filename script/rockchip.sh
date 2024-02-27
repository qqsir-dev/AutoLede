#!/bin/bash
#===============================================
# Description: R86S
# File name: rockchip.sh
# Lisence: MIT
# Author: qqsir
#===============================================

# Test kernel 6.1
sed -i 's/5.15/6.1/g' target/linux/rockchip/Makefile

# Network Configuration
sed -i "/exit/iuci set network.wan.ifname=\'eth2\'\nuci set network.wan.proto=\'pppoe\'\nuci set network.wan.username=\'990001257663\'\nuci set network.wan.password=\'u6s3x4r8\'\nuci set network.lan.netmask=\'255.255.255.0\'\nuci set network.lan.dns=\'119.29.29.29 223.5.5.5 114.114.114.114\'\nuci set network.lan.ip6assign=\'64\'\nuci set network.lan.ifname=\'eth0 eth1 eth3\'\nuci set network.wan6.ifname=\'@wan\'\nuci commit network\nuci set dhcp.lan.ignore=\'0\'\nuci set dhcp.lan.start=\'150\'\nuci set dhcp.lan.limit=\'100\'\nuci set dhcp.lan.ra_management=\'1\'\nuci add_list dhcp.lan.dhcp_option=\'6,223.5.5.5,119.29.29.29,114.114.114.114\'\nuci set dhcp.lan.force=\'1\'\nuci set dhcp.lan.ra=\'hybrid\'\nuci set dhcp.lan.ra_default=\'1\'\nuci set dhcp.lan.dhcpv6=\'relay\'\nuci set dhcp.lan.ndp=\'relay\'\nuci add dhcp host\nuci add dhcp host\nuci set dhcp.@host[-1].name=\'EAX80\'\nuci set dhcp.@host[-1].dns=\'1\'\nuci set dhcp.@host[-1].mac=\'3c:37:86:c8:e8:05\'\nuci set dhcp.@host[-1].ip=\'192.168.1.6\'\nuci set dhcp.@host[-1].leasetime=\'infinite\'\nuci commit dhcp\nuci set ddns.aliyun=\'service\'\nuci set ddns.aliyun.service_name=\'aliyun.com\'\nuci set ddns.aliyun.enabled=\'1\'\nuci set ddns.aliyun.lookup_host=\'fhome.bmwlive.club\'\nuci set ddns.aliyun.domain=\'fhome.bmwlive.club\'\nuci set ddns.aliyun.username=\'LTAIHiwKt52WZmKg\'\nuci set ddns.aliyun.password=\'Wlxr4IEL1IQKPtXaBlhVlGWqefF8BK\'\nuci set uci set ddns.aliyun.ip_source=\'web\'\nuci set ddns.aliyun.ip_url=\'http://ip.3322.net\'\nuci set ddns.aliyun.bind_network=\'wan\'\nuci commit ddns\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp\'\nuci set firewall.@redirect[-1].src_dport=\'8098\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.1.1\'\nuci set firewall.@redirect[-1].dest_port=\'80\'\nuci set firewall.@redirect[-1].name=\'Router\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp\'\nuci set firewall.@redirect[-1].src_dport=\'19999\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.1.1\'\nuci set firewall.@redirect[-1].dest_port=\'19999\'\nuci set firewall.@redirect[-1].name=\'LedeNetdata\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp\'\nuci set firewall.@redirect[-1].src_dport=\'7681\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.1.1\'\nuci set firewall.@redirect[-1].dest_port=\'7681\'\nuci set firewall.@redirect[-1].name=\'TTYD\'\nuci commit firewall\n" package/lean/default-settings/files/zzz-default-settings


# 修改默认IP
# sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 更改默认 Shell 为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 自动登录
# sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config
sed -i 's/option interface/# option interface/g' feeds/packages/utils/ttyd/files/ttyd.config

# Set Default Language - English
# sed -i "/exit/ised -i \"s/'zh_cn'/'en'/g\" /etc/config/luci\n" package/base-files/files/etc/rc.local

# 移除要替换的包
# rm -rf feeds/packages/net/mosdns
# rm -rf feeds/packages/net/msd_lite
# rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/themes/luci-theme-argon
# rm -rf feeds/luci/themes/luci-theme-netgear
# rm -rf feeds/luci/applications/luci-app-dockerman
# rm -rf feeds/luci/applications/luci-app-mosdns
# rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 添加额外插件
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-filebrowser luci-app-ssr-mudb-server
git_sparse_clone openwrt-18.06 https://github.com/immortalwrt/luci applications/luci-app-eqos
# git_sparse_clone master https://github.com/syb999/openwrt-19.07.1 package/network/services/msd_lite

# 科学上网插件
git clone --depth=1 https://github.com/fw876/helloworld package/luci-app-ssr-plus
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash

# Themes
git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
git_sparse_clone main https://github.com/haiibo/packages luci-theme-atmaterial luci-theme-opentomcat luci-theme-netgear

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/pics/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 晶晨宝盒
git_sparse_clone main https://github.com/ophub/luci-app-amlogic luci-app-amlogic
sed -i "s|firmware_repo.*|firmware_repo 'https://github.com/haiibo/OpenWrt'|g" package/luci-app-amlogic/root/etc/config/amlogic
# sed -i "s|kernel_path.*|kernel_path 'https://github.com/ophub/kernel'|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8_PLUS|g" package/luci-app-amlogic/root/etc/config/amlogic

# SmartDNS
# git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
# git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns

# msd_lite
# git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
# git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

# MosDNS
# git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns

# DDNS.to
# git_sparse_clone main https://github.com/linkease/nas-packages-luci luci/luci-app-ddnsto
# git_sparse_clone master https://github.com/linkease/nas-packages network/services/ddnsto

# Alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist

# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

# 在线用户
git_sparse_clone main https://github.com/haiibo/packages luci-app-onliner
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by qqsir/g" package/lean/default-settings/files/zzz-default-settings

# 修复 hostapd 报错
# cp -f $GITHUB_WORKSPACE/scripts/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

# 修复 armv8 设备 xfsprogs 报错
sed -i 's/TARGET_CFLAGS.*/TARGET_CFLAGS += -DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/g' feeds/packages/utils/xfsprogs/Makefile

# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 取消主题默认设置
find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

# 调整 Docker 到 服务 菜单
sed -i 's/"admin"/"admin", "services"/g' feeds/luci/applications/luci-app-dockerman/luasrc/controller/*.lua
sed -i 's/"admin"/"admin", "services"/g; s/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/model/cbi/dockerman/*.lua
sed -i 's/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/*.htm
sed -i 's|admin\\|admin\\/services\\|g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/container.htm

# 调整 V2ray服务器 到 VPN 菜单
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

./scripts/feeds update -a
./scripts/feeds install -a

# GoLang
rm -rf feeds/packages/lang/golang && git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

