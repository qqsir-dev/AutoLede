#!/bin/bash
#===============================================
# Description: X86 Main Router
# File name: ledeMainRouter.sh
# Lisence: MIT
# Author: qqsir
#===============================================
# GoLang
rm -rf feeds/packages/lang/golang && git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# 移除要替换的包
rm -rf feeds/packages/utils/v2dat
# rm -rf feeds/packages/net/mosdns
# rm -rf feeds/packages/net/msd_lite
# rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/themes/luci-theme-argon
# rm -rf feeds/luci/themes/luci-theme-netgear
# rm -rf feeds/luci/applications/luci-app-mosdns
# rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan
rm -rf feeds/packages/net/v2ray-geodata

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
# git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
# git clone --depth=1 -b master https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
# git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
# git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-filebrowser luci-app-ssr-mudb-server
# git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-eqos
# git_sparse_clone master https://github.com/syb999/openwrt-19.07.1 package/network/services/msd_lite

# 科学上网插件
git_sparse_clone dev https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy
# git clone --depth=1 https://github.com/fw876/helloworld package/luci-app-ssr-plus
# svn export https://github.com/haiibo/packages/trunk/luci-app-vssr package/luci-app-vssr
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
git_sparse_clone dev https://github.com/vernesong/OpenClash luci-app-openclash

# Themes
git clone --depth=1 -b master https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
git clone --depth=1 -b master https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
git_sparse_clone main https://github.com/haiibo/packages luci-theme-atmaterial luci-theme-opentomcat luci-theme-netgear

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/pics/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# SmartDNS
# git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
# git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns

# msd_lite
# git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
# git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

# MosDNS
# drop mosdns and v2ray-geodata packages that come with the source
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# DDNS.to
# git_sparse_clone main https://github.com/linkease/nas-packages-luci luci/luci-app-ddnsto
# git_sparse_clone master https://github.com/linkease/nas-packages network/services/ddnsto

# Alist
git clone -b lua --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist

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
# cp -f $GITHUB_WORKSPACE/script/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 取消主题默认设置
find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

# 调整 Docker 到 服务 菜单
# sed -i 's/"admin"/"admin", "services"/g' feeds/luci/applications/luci-app-dockerman/luasrc/controller/*.lua
# sed -i 's/"admin"/"admin", "services"/g; s/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/model/cbi/dockerman/*.lua
# sed -i 's/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/*.htm
# sed -i 's|admin\\|admin\\/services\\|g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/container.htm

# 调整 V2ray服务器 到 VPN 菜单
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

# add Mihomo
# git_sparse_clone main https://github.com/morytyann/OpenWrt-mihomo luci-app-mihomo mihomo

./scripts/feeds update -a
./scripts/feeds install -a

# Test kernel 6.6
# sed -i 's/6.1/6.6/g' target/linux/x86/Makefile

# Network Configuration
sed -i "/exit/iuci set network.wan.device=\'eth1\'\nuci set network.wan.ifname=\'eth1\'\nuci set network.wan.proto=\'pppoe\'\nuci set network.wan.username=\'990003835168\'\nuci set network.wan.password=\'k5k4t5b6\'\nuci set network.lan.netmask=\'255.255.255.0\'\nuci set network.lan.dns=\'192.168.50.5 119.29.29.29 223.5.5.5\'\nuci set network.lan.ip6assign=\'64\'\nuci set network.@device[0].ports=\'eth0 eth2 eth3 eth4\'\nuci set network.lan.device=\'br-lan\'\nuci set network.lan.ifname=\'eth0 eth2 eth3 eth4\'\nuci set network.wan6.device=\'@wan\'\nuci set network.wan6.ifname=\'eth1\'\nuci commit network\nuci set dhcp.lan.ignore=\'0\'\nuci set dhcp.lan.start=\'150\'\nuci set dhcp.lan.limit=\'100\'\nuci set dhcp.lan.ra_management=\'1\'\nuci add_list dhcp.lan.dhcp_option=\'6,192.168.50.5,119.29.29.29\'\nuci set dhcp.lan.force=\'1\'\nuci set dhcp.lan.ra=\'hybrid\'\nuci set dhcp.lan.ra_default=\'1\'\nuci set dhcp.lan.dhcpv6=\'relay\'\nuci set dhcp.lan.ndp=\'relay\'\nuci add dhcp host\nuci set dhcp.@host[-1].name=\'HOME-SRV\'\nuci set dhcp.@host[-1].dns=\'1\'\nuci set dhcp.@host[-1].mac=\'90:2e:16:bd:0b:cc\'\nuci set dhcp.@host[-1].ip=\'192.168.50.8\'\nuci set dhcp.@host[-1].leasetime=\'infinite\'\nuci add dhcp host\nuci set dhcp.@host[-1].name=\'AP\'\nuci set dhcp.@host[-1].dns=\'1\'\nuci set dhcp.@host[-1].mac=\'60:cf:84:28:8f:80\'\nuci set dhcp.@host[-1].ip=\'192.168.50.6\'\nuci set dhcp.@host[-1].leasetime=\'infinite\'\nuci commit dhcp\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'1688\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.2\'\nuci set firewall.@redirect[-1].dest_port=\'1688\'\nuci set firewall.@redirect[-1].name=\'KMS\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].proto=\'tcp\'\nuci set firewall.@redirect[-1].src_dport=\'3389\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.8\'\nuci set firewall.@redirect[-1].dest_port=\'3389\'\nuci set firewall.@redirect[-1].name=\'RDP\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'2302\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.8\'\nuci set firewall.@redirect[-1].dest_port=\'2302\'\nuci set firewall.@redirect[-1].name=\'DayZ\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'udp\'\nuci set firewall.@redirect[-1].src_dport=\'27016\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.8\'\nuci set firewall.@redirect[-1].dest_port=\'27016\'\nuci set firewall.@redirect[-1].name=\'DayZ\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'2308\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.8\'\nuci set firewall.@redirect[-1].dest_port=\'2308\'\nuci set firewall.@redirect[-1].name=\'DayZ\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'8098\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.2\'\nuci set firewall.@redirect[-1].dest_port=\'80\'\nuci set firewall.@redirect[-1].name=\'Router\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'8043\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.2\'\nuci set firewall.@redirect[-1].dest_port=\'443\'\nuci set firewall.@redirect[-1].name=\'Router\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'8099\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.9\'\nuci set firewall.@redirect[-1].dest_port=\'19999\'\nuci set firewall.@redirect[-1].name=\'Netdata\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'9090\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.2\'\nuci set firewall.@redirect[-1].dest_port=\'9090\'\nuci set firewall.@redirect[-1].name=\'OpenClash\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'19999\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.2\'\nuci set firewall.@redirect[-1].dest_port=\'19999\'\nuci set firewall.@redirect[-1].name=\'LedeNetdata\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'7681\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.2\'\nuci set firewall.@redirect[-1].dest_port=\'7681\'\nuci set firewall.@redirect[-1].name=\'TTYD\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp\'\nuci set firewall.@redirect[-1].src_dport=\'8095\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.5\'\nuci set firewall.@redirect[-1].dest_port=\'80\'\nuci set firewall.@redirect[-1].name=\'ADGuard\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp\'\nuci set firewall.@redirect[-1].src_dport=\'8096\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.10\'\nuci set firewall.@redirect[-1].dest_port=\'80\'\nuci set firewall.@redirect[-1].name=\'ESXi\'\nuci commit firewall\nuci set ddns.AliDDNS=\'service\'\nuci set ddns.AliDDNS.service_name=\'aliyun.com\'\nuci set ddns.AliDDNS.enabled=\'1\'\nuci set ddns.AliDDNS.lookup_host=\'homev6.bmwlive.club\'\nuci set ddns.AliDDNS.domain=\'homev6.bmwlive.club\'\nuci set ddns.AliDDNS.username=\'LTAIHiwKt52WZmKg\'\nuci set ddns.AliDDNS.password=\'Wlxr4IEL1IQKPtXaBlhVlGWqefF8BK\'\nuci set ddns.AliDDNS.use_ipv6=\'1\'\nuci set ddns.AliDDNS.ip_source=\'network\'\nuci set ddns.AliDDNS.ip_network=\'lan\'\nuci set ddns.aliyun=\'service\'\nuci set ddns.aliyun.service_name=\'aliyun.com\'\nuci set ddns.aliyun.enabled=\'1\'\nuci set ddns.aliyun.lookup_host=\'home.bmwlive.club\'\nuci set ddns.aliyun.domain=\'home.bmwlive.club\'\nuci set ddns.aliyun.username=\'LTAIHiwKt52WZmKg\'\nuci set ddns.aliyun.password=\'Wlxr4IEL1IQKPtXaBlhVlGWqefF8BK\'\nuci set uci set ddns.aliyun.ip_source=\'web\'\nuci set ddns.aliyun.ip_url=\'http://ip.3322.net\'\nuci set ddns.aliyun.bind_network=\'wan\'\nuci commit ddns\nuci set luci.main.lang=\'en\'\nuci commit luci\n" package/lean/default-settings/files/zzz-default-settings

# 修改默认IP - luci2
sed -i 's/192.168.1.1/192.168.50.2/g' package/base-files/luci2/bin/config_generate

# 修改默认IP - 18.06
sed -i 's/192.168.1.1/192.168.50.2/g' package/base-files/files/bin/config_generate

# 更改默认 Shell 为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 自动登录
# sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# Set Default Language - English
# sed -i "/exit/ised -i \"s/'zh_cn'/'en'/g\" /etc/config/luci\n" package/base-files/files/etc/rc.local

# CHG Netdata support SSL
# sed -i 's/http/https/g' package/feeds/luci/luci-app-netdata/luasrc/view/netdata/netdata.htm

# uhttpd cert
# sed -i 's/uhttpd.crt/uhttpd.pem/g' package/network/services/uhttpd/files/uhttpd.config

# CHG Netdata support SSL
# sed -i 's/DEPENDS:=+zlib +libuuid +libuv +libmnl +libjson-c/DEPENDS:=+zlib +libuuid +libuv +libmnl +libjson-c +libopenssl/g' feeds/packages/admin/netdata/Makefile
# sed -i 's/disable-https/enable-https/g' feeds/packages/admin/netdata/Makefile
# sed -i '/\[\plugins/i\        SSL certificate = /etc/netdata/ssl/cert.pem\n        SSL key = /etc/netdata/ssl/key.pem\n' feeds/packages/admin/netdata/files/netdata.conf
# Netdata ACL
sed -i 's/allow connections from = localhost/allow connections from = * localhost/g' feeds/packages/admin/netdata/files/netdata.conf
sed -i 's/allow dashboard from = localhost/allow dashboard from = * localhost/g' feeds/packages/admin/netdata/files/netdata.conf

# Rename LEDE
# sed -i 's/hostname=\'LEDE\'/hostname=\'TimWrt\'/g' package/base-files/luci2/bin/config_generate

# TTYD SSL+IPv6 Config
# sed -i 's/option interface/# option interface/g' feeds/packages/utils/ttyd/files/ttyd.config
# sed -i "/command/a\        option ipv6 'on'\n        option ssl '1'\n        option ssl_cert /etc/uhttpd.pem\n        option ssl_key /etc/uhttpd.key" feeds/packages/utils/ttyd/files/ttyd.config
