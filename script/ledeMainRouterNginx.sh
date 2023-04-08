#!/bin/bash

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add luci-theme-argon
rm -rf ../../feeds/luci/themes/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ./luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/pics/bg1.jpg luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
popd

# Set BIOS Boot Partition to 1 MiB
sed -i 's/256/1024/g' target/linux/x86/image/Makefile

# Modify default IP
sed -i 's/192.168.1.1/192.168.50.2/g' package/base-files/files/bin/config_generate
sed -i '/uci commit system/i\uci set system.@system[0].hostname='TimWrt'' package/lean/default-settings/files/zzz-default-settings
sed -i "s/OpenWrt /YG @ TimWrt /g" package/lean/default-settings/files/zzz-default-settings
# find package/*/ feeds/*/ -maxdepth 6 -path "*luci-app-smartdns/luasrc/controller/smartdns.lua" | xargs -i sed -i 's/\"SmartDNS\")\, 4/\"SmartDNS\")\, 3/g' {} 
# Test kernel 6.1
sed -i 's/5.15/6.1/g' target/linux/x86/Makefile

# Network Configuration
sed -i "/exit/iuci set network.wan.ifname=\'eth0\'\nuci set network.wan6.ifname=\'eth1\'\nuci set network.wan.proto=\'pppoe\'\nuci set network.wan.username=\'990003835168\'\nuci set network.wan.password=\'k5k4t5b6\'\nuci set network.lan.netmask=\'255.255.255.0\'\nuci set network.lan.dns=\'192.168.50.5 119.29.29.29 223.5.5.5\'\nuci set network.lan.ifname=\'eth2 eth3 eth4\'\nuci commit network\nuci set dhcp.lan.ignore=\'0\'\nuci set dhcp.lan.start=\'150\'\nuci set dhcp.lan.limit=\'100\'\nuci set dhcp.lan.ra_management=\'1\'\nuci add_list dhcp.lan.dhcp_option=\'6,192.168.50.5,119.29.29.29\'\nuci set dhcp.lan.force=\'1\'\nuci add dhcp host\nuci set dhcp.@host[-1].name=\'HOME-SRV\'\nuci set dhcp.@host[-1].dns=\'1\'\nuci set dhcp.@host[-1].mac=\'90:2e:16:bd:0b:cc\'\nuci set dhcp.@host[-1].ip=\'192.168.50.8\'\nuci set dhcp.@host[-1].leasetime=\'infinite\'\nuci add dhcp host\nuci set dhcp.@host[-1].name=\'EAX80\'\nuci set dhcp.@host[-1].dns=\'1\'\nuci set dhcp.@host[-1].mac=\'3c:37:86:c8:e8:05\'\nuci set dhcp.@host[-1].ip=\'192.168.50.6\'\nuci set dhcp.@host[-1].leasetime=\'infinite\'\nuci add dhcp host\nuci set dhcp.@host[-1].name=\'ESIWIN\'\nuci set dhcp.@host[-1].dns=\'1\'\nuci set dhcp.@host[-1].mac=\'d8:f8:83:36:03:49\'\nuci set dhcp.@host[-1].ip=\'192.168.50.68\'\nuci set dhcp.@host[-1].leasetime=\'infinite\'\nuci commit dhcp\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'1688\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.2\'\nuci set firewall.@redirect[-1].dest_port=\'1688\'\nuci set firewall.@redirect[-1].name=\'KMS\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].proto=\'tcp\'\nuci set firewall.@redirect[-1].src_dport=\'3389\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.8\'\nuci set firewall.@redirect[-1].dest_port=\'3389\'\nuci set firewall.@redirect[-1].name=\'RDP\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'2302\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.8\'\nuci set firewall.@redirect[-1].dest_port=\'2302\'\nuci set firewall.@redirect[-1].name=\'DayZ\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'udp\'\nuci set firewall.@redirect[-1].src_dport=\'27016\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.8\'\nuci set firewall.@redirect[-1].dest_port=\'27016\'\nuci set firewall.@redirect[-1].name=\'DayZ\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'2308\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.8\'\nuci set firewall.@redirect[-1].dest_port=\'2308\'\nuci set firewall.@redirect[-1].name=\'DayZ\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'8098\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.2\'\nuci set firewall.@redirect[-1].dest_port=\'80\'\nuci set firewall.@redirect[-1].name=\'Router\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'8095\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.5\'\nuci set firewall.@redirect[-1].dest_port=\'443\'\nuci set firewall.@redirect[-1].name=\'ADGuard\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'8096\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.10\'\nuci set firewall.@redirect[-1].dest_port=\'443\'\nuci set firewall.@redirect[-1].name=\'ESXi\'\nuci add firewall redirect\nuci set firewall.@redirect[-1].target=\'DNAT\'\nuci set firewall.@redirect[-1].src=\'wan\'\nuci set firewall.@redirect[-1].dest=\'lan\'\nuci set firewall.@redirect[-1].proto=\'tcp udp\'\nuci set firewall.@redirect[-1].src_dport=\'8094\'\nuci set firewall.@redirect[-1].dest_ip=\'192.168.50.7\'\nuci set firewall.@redirect[-1].dest_port=\'5700\'\nuci set firewall.@redirect[-1].name=\'QL\'\nuci commit firewall\nuci commit firewall\nuci set ddns.AliDDNS=\'service\'\nuci set ddns.AliDDNS.service_name=\'aliyun.com\'\nuci set ddns.AliDDNS.enabled=\'1\'\nuci set ddns.AliDDNS.lookup_host=\'home.bmwlive.club\'\nuci set ddns.AliDDNS.domain=\'home.bmwlive.club\'\nuci set ddns.AliDDNS.username=\'LTAIHiwKt52WZmKg\'\nuci set ddns.AliDDNS.password=\'Wlxr4IEL1IQKPtXaBlhVlGWqefF8BK\'\nuci set ddns.AliDDNS.ip_source=\'web\'\nuci set ddns.AliDDNS.ip_url=\'http://ip.3322.net\'\nuci set ddns.AliDDNS.bind_network=\'wan\'\nuci commit ddns\n" package/lean/default-settings/files/zzz-default-settings

# CHG Netdata support SSL
sed -i 's/DEPENDS:=+zlib +libuuid +libuv +libmnl +libjson-c/DEPENDS:=+zlib +libuuid +libuv +libmnl +libjson-c +libopenssl/g' feeds/packages/admin/netdata/Makefile
sed -i 's/disable-https/enable-https/g' feeds/packages/admin/netdata/Makefile
sed -i '/\[\plugins/i\        SSL certificate = /etc/netdata/ssl/cert.pem\n        SSL key = /etc/netdata/ssl/key.pem\n' feeds/packages/admin/netdata/files/netdata.conf
sed -i 's/http/https/g' package/feeds/luci/luci-app-netdata/luasrc/view/netdata/netdata.htm

# turn on turboacc bbr_cca
# sed -i $'s/option bbr_cca \'0\'/option bbr_cca \'1\'/g' feeds/luci/applications/luci-app-turboacc/root/etc/config/turboacc
# sed -i $'s/option sfe_flow \'1\'/option sfe_flow \'0\'/g' feeds/luci/applications/luci-app-turboacc/root/etc/config/turboacc

# Set Default Language - English & Nginx client_max_body_size 2048M
sed -i "/exit/ised -i \"s/'zh_cn'/'en'/g\" /etc/config/luci\nsed -i \"s/'128M'/'2048M'/g\" /etc/nginx/uci.conf\n" package/base-files/files/etc/rc.local

# Set Nginx client_max_body_size 2048M
# sed -i 's/128M/2048M/g' /etc/nginx/uci.conf

# Modify ShadowSocksR Plus+ Menu order
find package/*/ feeds/*/ -maxdepth 6 -path "*helloworld/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua" | xargs -i sed -i 's/\"ShadowSocksR Plus+\")\, 10/\"ShadowSocksR Plus+\")\, 0/g' {}

# Add zhipin.com to ssr white list
sed -i '$a\zhipin.com\nmacenjoy.co\niqiyi.com\nmi.com\nfesco.com.cn' feeds/helloworld/luci-app-ssr-plus/root/etc/ssrplus/white.list

# Custom configs
# git am $GITHUB_WORKSPACE/patches/lean/*.patch
# git am $GITHUB_WORKSPACE/patches/*.patch
echo -e " qqsir's TimWrt built on "$(date +%Y.%m.%d)"\n -----------------------------------------------------" >> package/base-files/files/etc/banner
echo 'net.bridge.bridge-nf-call-iptables=0' >> package/base-files/files/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-ip6tables=0' >> package/base-files/files/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-arptables=0' >> package/base-files/files/etc/sysctl.conf
echo 'net.bridge.bridge-nf-filter-vlan-tagged=0' >> package/base-files/files/etc/sysctl.conf
