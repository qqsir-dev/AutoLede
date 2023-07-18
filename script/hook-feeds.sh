#!/bin/bash
pushd customfeeds

# CHG Netdata support SSL
sed -i 's/DEPENDS:=+zlib +libuuid +libuv +libmnl +libjson-c/DEPENDS:=+zlib +libuuid +libuv +libmnl +libjson-c +libopenssl/g' packages/admin/netdata/Makefile
sed -i 's/disable-https/enable-https/g' packages/admin/netdata/Makefile
sed -i '/\[\plugins/i\        SSL certificate = /etc/netdata/ssl/cert.pem\n        SSL key = /etc/netdata/ssl/key.pem\n' packages/admin/netdata/files/netdata.conf
sed -i 's/allow connections from = localhost/allow connections from = localhost 2408:*/g' packages/admin/netdata/files/netdata.conf
sed -i 's/allow dashboard from = localhost/allow dashboard from = localhost 2408:*/g' packages/admin/netdata/files/netdata.conf

# TTYD SSL+IPv6 Config
sed -i 's/option interface/# option interface/g' packages/utils/ttyd/files/ttyd.config
sed -i "/command/a\        option ipv6 'on'\n        option ssl '1'\n        option ssl_cert /etc/uhttpd.pem\n        option ssl_key /etc/uhttpd.key" packages/utils/ttyd/files/ttyd.config
popd

# Set to local feeds
pushd customfeeds/packages
export packages_feed="$(pwd)"
popd
pushd customfeeds/luci
export luci_feed="$(pwd)"
popd
sed -i '/src-git packages/d' feeds.conf.default
echo "src-link packages $packages_feed" >> feeds.conf.default
sed -i '/src-git luci/d' feeds.conf.default
echo "src-link luci $luci_feed" >> feeds.conf.default
sed -i '/helloworld/d' feeds.conf.default
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> feeds.conf.default

# Update feeds
./scripts/feeds update -a
