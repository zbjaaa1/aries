#!/bin/sh
set -eu

files="device/community/device-google-gru/deviceinfo device/community/device-google-kukui/deviceinfo device/community/device-google-oak/deviceinfo device/community/device-google-snow/deviceinfo device/community/device-google-trogdor/deviceinfo device/community/device-google-veyron/deviceinfo device/community/device-lenovo-21bx/deviceinfo device/testing/device-acer-aspire1/deviceinfo device/testing/device-amediatech-x96-mini/deviceinfo device/testing/device-google-asurada/deviceinfo device/testing/device-google-cherry/deviceinfo device/testing/device-google-corsola/deviceinfo device/testing/device-google-nyan-big/deviceinfo device/testing/device-google-nyan-blaze/deviceinfo device/testing/device-google-smaug/deviceinfo device/testing/device-htc-protou/deviceinfo device/testing/device-inet-a33/deviceinfo device/testing/device-lenovo-flex-5g/deviceinfo device/testing/device-lenovo-tb-x704f/deviceinfo device/testing/device-lenovo-tb8504f/deviceinfo device/testing/device-lenovo-yoga-5g/deviceinfo device/testing/device-librecomputer-lafrite/deviceinfo device/testing/device-librecomputer-lepotato/deviceinfo device/testing/device-librecomputer-solitude/deviceinfo device/testing/device-samsung-afyonltecan/deviceinfo device/testing/device-samsung-gts210velte/deviceinfo device/testing/device-samsung-gts210vewifi/deviceinfo device/testing/device-samsung-j6primelte/deviceinfo device/testing/device-samsung-ms013g/deviceinfo device/testing/device-samsung-s3ve3g/deviceinfo device/testing/device-samsung-starqltechn/deviceinfo device/testing/device-samsung-w767/deviceinfo device/testing/device-xiaomi-aries/deviceinfo device/testing/device-xiaomi-davinci/deviceinfo device/testing/device-xiaomi-miatoll/deviceinfo device/testing/device-xiaomi-polaris/deviceinfo device/testing/device-xunlong-orangepi-pc/deviceinfo device/testing/device-xunlong-orangepi5-plus/deviceinfo device/archived/device-samsung-a5ulte-downstream/deviceinfo device/testing/device-xiaomi-surya/deviceinfo"

packages=""
for devinfo in $files; do
	sed -i 's|console=null|quiet loglevel=2|' "$devinfo"
	packages="$packages $(echo "$devinfo" | cut -d/ -f3)"
done

pmbootstrap checksum $packages
pmbootstrap pkgver_bump $packages



# for package in $packages; do
# 	echo "bumping pkgver in $package..."
# 	apkbuild="$(fd -t f -p "$package/APKBUILD")"
# 	if [ -z "$apkbuild" ]; then
# 		echo "Unable to find APKBUILD for: $package"
# 		exit 1
# 	fi
# 	ver="$(rg -NL ^pkgver= "$apkbuild" | cut -d= -f2)"
# 	echo "... old version: $ver"
# 	ver=$((ver+1))

# 	if [ -z "$ver" ]; then
# 		echo "Unable to find pkgver for: $apkbuild"
# 		exit 1
# 	fi

# 	sed -i 's|^pkgver=.*|pkgver='"$ver"'|' "$apkbuild"
# 	sed -i 's|^pkgrel=.*|pkgrel=0|' "$apkbuild"
# done
