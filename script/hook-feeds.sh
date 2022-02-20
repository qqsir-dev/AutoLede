#!/bin/bash
# pushd customfeeds

# Add luci-app-netdata
# rm -rf packages/admin/netdata
# svn co https://github.com/281677160/openwrt-package/trunk/feeds/packages/net/netdata packages/admin/netdata
# rm -rf ../package/lean/luci-app-netdata
# svn co https://github.com/281677160/openwrt-package/trunk/feeds/luci/applications/luci-app-netdata luci/applications/luci-app-netdata

# popd

# Set to local feeds
# pushd customfeeds/packages
# export packages_feed="$(pwd)"
# popd
# pushd customfeeds/luci
# export luci_feed="$(pwd)"
# popd
# sed -i '/src-git packages/d' feeds.conf.default
# echo "src-link packages $packages_feed" >> feeds.conf.default
# sed -i '/src-git luci/d' feeds.conf.default
# echo "src-link luci $luci_feed" >> feeds.conf.default
sed -i '/helloworld/d' feeds.conf.default
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> feeds.conf.default

# Add luci-app-unblockneteasemusic
rm -rf feeds/luci/applications/luci-app-unblockmusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git feeds/luci/applications/luci-app-unblockmusic

# Add luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon feeds/luci/themes/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config feeds/luci/applications/luci-app-argon-config
rm -rf feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/pics/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# Update feeds
./scripts/feeds update -a
