#!/bin/sh -e
# This script fails on error (-e). We don't want an error while generating the
# initramfs to go unnoticed, it may lead to the device not booting anymore.

# Only invoke mkinitfs if the deviceinfo exists in the rootfs
if ! [ -f /usr/share/deviceinfo/deviceinfo ]; then
	exit 0
fi

for release in $(find /usr/share/kernel -type f -name kernel.release); do
	releases="$releases $release"
	/usr/sbin/mkinitfs -k "$(cat "$release")"
done

# Remove the now-defunct initramfs/kernel files without the version suffix
for file in /boot/initramfs /boot/linux.efi /boot/vmlinuz; do
	if [ -f "$file" ]; then
		rm "$file"
	fi
done
