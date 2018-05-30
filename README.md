# port_freertos_to_qemu_a57_virt

*	Target: Porting FreeRTOS to QEMU (-M virt -cpu cortex-a57). I am studying now.

*	The base is [aarch64-bare-metal-qemu]( https://github.com/freedomtan/aarch64-bare-metal-qemu). 

*	Study case (./Demo/):
	*	Demo/ex01 is aarch64-bare-metal-qemu sample.

	*	Demo/ex02:
		*	It bases ex01
		*	Reference FreeRTOSv10.0.1/FreeRTOS/Demo/CORTEX_A53_64-bit_UltraScale_MPSoC and [FreeRTOS-GCC-ARM926ejs](https://github.com/jkovacic/FreeRTOS-GCC-ARM926ejs) 

	*	[ARM926 interrupts in QEMU](https://balau82.wordpress.com/2012/04/15/arm926-interrupts-in-qemu/)
		*	The basic uart interrupt example

