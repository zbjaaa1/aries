fatload mmc 0:1 0x21000000 uImage
fatload mmc 0:1 0x23000000 uInitrd
fatload mmc 0:1 0x24000000 dtbs/meson8m2-mxiii-plus.dtb
setenv bootargs "console=ttyAML0,115200n8 console=tty0 no_console_suspend consoleblank=0"
bootm 0x21000000 0x23000000 0x24000000
