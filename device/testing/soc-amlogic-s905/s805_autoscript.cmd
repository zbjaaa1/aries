fatload mmc 0:1 0x21000000 uImage
fatload mmc 0:1 0x22000000 initramfs.uImage
fatload mmc 0:1 0x21800000 dtbs/meson8m2-mxiii-plus.dtb
setenv bootargs "console=ttyAML0,115200"
bootm 0x21000000 0x22000000 0x21800000
