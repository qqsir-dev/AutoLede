#!/bin/bash

PKG_PATCH="$OPENWRT_PATH/package/"

CORE_VER="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/core_version"
# CORE_TYPE=$(echo $WRT_TARGET | grep -Eiq "64|86" && echo "amd64" || echo "arm64")
CORE_TUN_VER=$(curl -sL $CORE_VER | sed -n "2{s/\r$//;p;q}")

CORE_DEV="https://github.com/vernesong/OpenClash/raw/core/dev/dev/clash-linux-${1}.tar.gz"
CORE_MATE="https://github.com/vernesong/OpenClash/raw/core/dev/meta/clash-linux-${1}.tar.gz"
CORE_TUN="https://github.com/vernesong/OpenClash/raw/core/dev/premium/clash-linux-${1}-$CORE_TUN_VER.gz"

GEO_MMDB="https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb"
GEO_SITE="https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat"
GEO_IP="https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat"
pwd
cd $PKG_PATCH/luci-app-openclash/root/etc/openclash/
pwd
ls
	curl -sL -o Country.mmdb $GEO_MMDB && echo "Country.mmdb done!"
	curl -sL -o GeoSite.dat $GEO_SITE && echo "GeoSite.dat done!"
	curl -sL -o GeoIP.dat $GEO_IP && echo "GeoIP.dat done!"

	mkdir core/ && cd core/

	curl -sL -o meta.tar.gz $CORE_MATE && tar -zxf meta.tar.gz && mv -f clash clash_meta && echo "meta done!"
	curl -sL -o tun.gz $CORE_TUN && gzip -d tun.gz && mv -f tun clash_tun && echo "tun done!"
	curl -sL -o dev.tar.gz $CORE_DEV && tar -zxf dev.tar.gz && echo "dev done!"
ls
	chmod +x * && rm -rf *.gz

	cd $PKG_PATCH && echo "openclash date has been updated!"
