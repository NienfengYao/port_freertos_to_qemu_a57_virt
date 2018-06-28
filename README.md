# port_freertos_to_qemu_a57_virt
*	Target: 
	* Porting FreeRTOS to QEMU (-M virt -cpu cortex-a57). I am studying now.

*	Study case (./Demo/):
	*	[aarch64-bare-metal-qemu]( https://github.com/freedomtan/aarch64-bare-metal-qemu). 
		*	Directly using UARTDR(UART Data Register) to send out the characters.	

	*	[ARM926 interrupts in QEMU](https://balau82.wordpress.com/2012/04/15/arm926-interrupts-in-qemu/)
		*	The basic uart interrupt example

	*	cortexa57_virt:
		*	I am porting here.
		*	It bases aarch64-bare-metal-qemu
		*	Reference FreeRTOSv10.0.1/FreeRTOS/Demo/CORTEX_A53_64-bit_UltraScale_MPSoC and [FreeRTOS-GCC-ARM926ejs](https://github.com/jkovacic/FreeRTOS-GCC-ARM926ejs) 

# Reference:
*	FreeRTOS-GCC-ARM926ejs
	*	[ARM9EJ-S Technical Reference Manual - DDI0222](http://infocenter.arm.com/help/topic/com.arm.doc.ddi0222b/DDI0222.pdf)
	*	[ARM926 interrupts in QEMU](https://balau82.wordpress.com/2012/04/15/arm926-interrupts-in-qemu/)
	*	[Building Bare-Metal ARM Systems with GNU: Part 2](https://www.embedded.com/design/mcus-processors-and-socs/4026075/Building-Bare-Metal-ARM-Systems-with-GNU-Part-2)
	*	[Writing ARM Assembly Language](http://www.keil.com/support/man/docs/armasm/armasm_dom1359731144635.htm)
	*	[ARM Architecture Reference Manual](https://www.scss.tcd.ie/~waldroj/3d1/arm_arm.pdf)
*	QEMU
	*	[QEMU version 2.12.50 User Documentation](https://qemu.weilnetz.de/doc/qemu-doc.html)
*	Makefile
	*	[Makefile範例教學](http://maxubuntu.blogspot.com/2010/02/makefile.html)
	*	[GNU 的連結工具 (ld, nm, objdump, ar)](http://sp1.wikidot.com/gnulinker)
	*	[GCC Command-Line Options](http://tigcc.ticalc.org/doc/comopts.html)
	*	[LD Index](https://sourceware.org/binutils/docs/ld/LD-Index.html#LD-Index)
*	FreeRTOS
	*	[FreeRTOS Tutorial](http://socialledge.com/sjsu/index.php/FreeRTOS_Tutorial)
*	GDB
	*	[GNU GDB Debugger Command Cheat Sheet](http://www.yolinux.com/TUTORIALS/GDB-Commands.html)
	*	[Debugging with GDB （入門篇）](http://www.study-area.org/goldencat/debug.htm)
	*	[Use Qemu GDB to forcely debug Linux early boot process ](https://mudongliang.github.io/2017/09/21/use-qemu-gdb-to-forcely-debug-linux-early-boot-process.html)
