#!/bin/bash
# pushd customfeeds

# Add luci-app-netdata
# rm -rf packages/admin/netdata
# svn co https://github.com/281677160/openwrt-package/trunk/feeds/packages/net/netdata packages/admin/netdata
# rm -rf ../package/lean/luci-app-netdata
# svn co https://github.com/281677160/openwrt-package/trunk/feeds/luci/applications/luci-app-netdata luci/applications/luci-app-netdata

# popd

# Set to local feeds
# pushd feeds/packages
# export packages_feed="$(pwd)"
# popd
# pushd feeds/luci
# export luci_feed="$(pwd)"
# popd
# sed -i '/src-git packages/d' feeds.conf.default
# echo "src-link packages $packages_feed" >> feeds.conf.default
# sed -i '/src-git luci/d' feeds.conf.default
# echo "src-link luci $luci_feed" >> feeds.conf.default

sed -i '/helloworld/d' feeds.conf.default
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> feeds.conf.default

# Update feeds
./scripts/feeds update -a
