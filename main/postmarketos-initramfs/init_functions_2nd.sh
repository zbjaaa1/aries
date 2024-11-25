#!/bin/sh
# Additional functions that depend on initramfs-extra
# Functions are notated with the reason they're only in
# initramfs-extra

# udevd is too big
setup_udev() {
	if ! command -v udevd > /dev/null || ! command -v udevadm > /dev/null; then
		echo "ERROR: udev not found!"
		return
	fi

	# This is the same series of steps performed by the udev,
	# udev-trigger and udev-settle RC services. See also:
	# - https://git.alpinelinux.org/aports/tree/main/eudev/setup-udev
	# - https://git.alpinelinux.org/aports/tree/main/udev-init-scripts/APKBUILD
	udevd -d --resolve-names=never
	udevadm trigger --type=devices --action=add
	udevadm settle
}

# parted is too big
resize_root_partition() {
	partition=$(find_root_partition)

	# Do not resize the installer partition
	if [ "$(blkid --label pmOS_install)" = "$partition" ]; then
		echo "Resize root partition: skipped (on-device installer)"
		return
	fi

	# Only resize the partition if it's inside the device-mapper, which means
	# that the partition is stored as a subpartition inside another one.
	# In this case we want to resize it to use all the unused space of the
	# external partition.
	if [ -z "${partition##"/dev/mapper/"*}" ] || [ -z "${partition##"/dev/dm-"*}" ]; then
		# Get physical device
		if [ -n "$SUBPARTITION_DEV" ]; then
			partition_dev="$SUBPARTITION_DEV"
		else
			partition_dev=$(dmsetup deps -o blkdevname "$partition" | \
				awk -F "[()]" '{print "/dev/"$2}')
		fi
		if has_unallocated_space "$partition_dev"; then
			echo "Resize root partition ($partition)"
			# unmount subpartition, resize and remount it
			kpartx -d "$partition"
			parted -f -s "$partition_dev" resizepart 2 100%
			kpartx -afs "$partition_dev"
		else
			echo "Not resizing root partition ($partition): no free space left"
		fi

	# Resize the root partition (non-subpartitions). Usually we do not want
	# this, except for QEMU devices and non-android devices (e.g.
	# PinePhone). For them, it is fine to use the whole storage device and
	# so we pass PMOS_FORCE_PARTITION_RESIZE as kernel parameter.
	elif grep -q PMOS_FORCE_PARTITION_RESIZE /proc/cmdline; then
		partition_dev="$(echo "$partition" | sed -E 's/p?2$//')"
		if has_unallocated_space "$partition_dev"; then
			echo "Resize root partition ($partition)"
			parted -f -s "$partition_dev" resizepart 2 100%
			partprobe
		else
			echo "Not resizing root partition ($partition): no free space left"
		fi

	# Resize the root partition (non-subpartitions) on Chrome OS devices.
	# Match $deviceinfo_cgpt_kpart not being empty instead of cmdline
	# because it does not make sense here as all these devices use the same
	# partitioning methods. This also resizes third partition instead of
	# second, because these devices have an additional kernel partition
	# at the start.
	elif [ -n "$deviceinfo_cgpt_kpart" ]; then
		partition_dev="$(echo "$partition" | sed -E 's/p?3$//')"
		if has_unallocated_space "$partition_dev"; then
			echo "Resize root partition ($partition)"
			parted -f -s "$partition_dev" resizepart 3 100%
			partprobe
		else
			echo "Not resizing root partition ($partition): no free space left"
		fi

	else
		echo "Unable to resize root partition: failed to find qualifying partition"
	fi
}

# resize2fs and resize.f2fs are too big
resize_root_filesystem() {
	show_splash "Resizing filesystem during initial boot..."
	partition="$(find_root_partition)"
	touch /etc/mtab # see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=673323
	type="$(get_partition_type "$partition")"
	case "$type" in
		ext4)
			echo "Resize 'ext4' root filesystem ($partition)"
			modprobe ext4
			resize2fs -f "$partition"
			;;
		f2fs)
			echo "Resize 'f2fs' root filesystem ($partition)"
			modprobe f2fs
			resize.f2fs "$partition"
			;;
		btrfs)
			echo "Resize 'btrfs' root filesystem ($partition)"
			modprobe btrfs
			resize_root_filesystem_tmp_btrfs="$(mktemp -d)"
			mount -t btrfs "$partition" "$resize_root_filesystem_tmp_btrfs"
			btrfs filesystem resize max "$resize_root_filesystem_tmp_btrfs"
			umount "$resize_root_filesystem_tmp_btrfs"
			unset resize_root_filesystem_tmp_btrfs
			;;
		*)	echo "WARNING: Can not resize '$type' filesystem ($partition)." ;;
	esac
	show_splash "Loading..."
}
