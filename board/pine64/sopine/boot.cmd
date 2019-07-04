setenv bootargs console=ttyS0,115200 root=/dev/mmcblk0p2 rootwait quiet

fatload mmc 0 $kernel_addr_r Image
fatload mmc 0 $fdt_addr_r sun50i-a64-sopine-baseboard.dtb

booti $kernel_addr_r - $fdt_addr_r
