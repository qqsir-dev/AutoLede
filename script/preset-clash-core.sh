#!/bin/bash

mkdir -p files/etc/openclash/core
CORE_VER="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/core_version"
CORE_TUN_VER=$(curl -sL $CORE_VER | sed -n "2{s/\r$//;p;q}")

CORE_DEV="https://github.com/vernesong/OpenClash/raw/core/dev/dev/clash-linux-${1}.tar.gz"
CORE_MATE="https://github.com/vernesong/OpenClash/raw/core/dev/meta/clash-linux-${1}.tar.gz"
CORE_TUN="https://github.com/vernesong/OpenClash/raw/core/dev/premium/clash-linux-${1}-$CORE_TUN_VER.gz"

GEO_MMDB="https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb"
GEO_SITE="https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat"
GEO_IP="https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat"

curl -sL -o files/etc/openclash/Country.mmdb $GEO_MMDB && echo "Country.mmdb done!"
curl -sL -o files/etc/openclash/GeoSite.dat $GEO_SITE && echo "GeoSite.dat done!"
curl -sL -o files/etc/openclash/GeoIP.dat $GEO_IP && echo "GeoIP.dat done!"

wget -qO- $CORE_DEV | tar xOvz > files/etc/openclash/core/clash
wget -qO- $CORE_TUN | gunzip -c > files/etc/openclash/core/clash_tun
wget -qO- $CORE_MATE | tar xOvz > files/etc/openclash/core/clash_meta

chmod +x files/etc/openclash/core/clash*
