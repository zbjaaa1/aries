#!/bin/sh

#export QEMU_MODULE_DIR=/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/usr/lib/qemu
#export GBM_DRIVERS_PATH=/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/usr/lib/xorg/modules/dri
#export LIBGL_DRIVERS_PATH=/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/usr/lib/xorg/modules/dri
#export GTK_THEME=Default
#export GDK_PIXBUF_MODULE_FILE=/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders-pmos-chroot.cache
#export XDG_DATA_DIRS=/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/usr/local/share:/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/usr/share

#/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/lib/ld-musl-aarch64.so.1 \
#	/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/usr/bin/taskset -c 0-3 \
#	/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/lib/ld-musl-aarch64.so.1 \
#	--library-path=/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/lib:/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/usr/lib:/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/usr/lib/pulseaudio \
#	/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/usr/bin/qemu-system-aarch64 \


# How pmb does it:
#qemu-system-aarch64 \
#	-nodefaults \
#	-kernel /home/clayton/.local/var/pmbootstrap_systemd/chroot_rootfs_qemu-aarch64/boot/vmlinuz-edge \
#	-initrd /home/clayton/.local/var/pmbootstrap_systemd/chroot_rootfs_qemu-aarch64/boot/initramfs \
#	-append 'console=tty1 console=ttyAMA0,38400n8 PMOS_NO_OUTPUT_REDIRECT PMOS_FORCE_PARTITION_RESIZE video=1024x768@60' \
#	-smp 4 \
#	-m 1024 \
#	-serial mon:stdio \
#	-drive file=/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/home/pmos/rootfs/qemu-aarch64.img,format=raw,if=virtio \
#	-device virtio-mouse-pci \
#	-device virtio-keyboard-pci \
#	-netdev user,id=net,hostfwd=tcp:127.0.0.1:2222-:22 \
#	-device virtio-net-pci,netdev=net \
#	-M virt \
#	-device virtio-gpu \
#	-enable-kvm \
#	-cpu host \
#	-display gtk,gl=on,show-cursor=on

qemu-system-aarch64 \
	-nodefaults \
	-kernel /home/clayton/.local/var/pmbootstrap_systemd/chroot_rootfs_qemu-aarch64/boot/vmlinuz-edge \
	-initrd /home/clayton/.local/var/pmbootstrap_systemd/chroot_rootfs_qemu-aarch64/boot/initramfs \
	-append 'console=tty1 console=ttyAMA0,38400n8 PMOS_NO_OUTPUT_REDIRECT PMOS_FORCE_PARTITION_RESIZE video=1024x768@60' \
	-smp 4 \
	-m 2048 \
	-serial mon:stdio \
	-drive file=/home/clayton/.local/var/pmbootstrap_systemd/chroot_native/home/pmos/rootfs/qemu-aarch64.img,format=raw,if=virtio \
	-device virtio-mouse-pci \
	-device virtio-keyboard-pci \
	-netdev user,id=net,hostfwd=tcp:127.0.0.1:2222-:22 \
	-device virtio-net-pci,netdev=net \
	-M virt \
	-cpu host \
	-machine virt,accel=kvm \
	-display gtk,show-tabs=on,gl=on \
	-device virtio-gpu-pci
	#-device virtio-gpu-gl
	# -device virtio-gpu-gl,stats=off,blob=on,hostmem=32G


# rob clark's qemu launch:
# /usr/local/virgl/bin/qemu-system-aarch64 \
#         -machine virt,accel=kvm -cpu host -m 24576 -smp 4 \
#         -drive if=none,id=sda,format=qcow2,file=/home/robclark/vm/debian.qcow2 \
#         -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/aarch64/QEMU_EFI-silent-pflash.raw \
#         -drive if=pflash,format=qcow2,file=/home/robclark/vm/debian12_VARS.qcow2 \
#         -device virtio-blk-device,drive=sda \
#         -device usb-ehci -device usb-kbd -device usb-mouse \
#         -net nic -net user,hostfwd=tcp::2270-:22 \
#         -device virtio-gpu-gl,stats=off,blob=on,hostmem=32G -display gtk,show-tabs=on,gl=on
