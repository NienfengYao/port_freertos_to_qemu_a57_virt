# port_freertos_to_qemu_a57_virt
* Porting FreeRTOS to QEMU (-M virt -cpu cortex-a57). I am studying now.
  * The booting procedure bases from [u-boot](u-boot/u-boot)
  * The FreeRTOS project bases from FreeRTOSv10.0.1/FreeRTOS/Demo/CORTEX_A53_64-bit_UltraScale_MPSoC
* Status
  * Basic Uart works.
    * uart_putc(), uart_puts(), uart_puthex()
  * Basic FreeRTOS works.
    * configASSERT(), xTaskCreate(), vTaskStartScheduler()
  * printf() works.
    
# Issues
* GDB can't step into main() if missing lable: magic_label in start.S (commit 0ddf0c433d759b763c84106ee4810e5f809a78c3)

# Reference:
* Project:
  * [aarch64-bare-metal-qemu]( https://github.com/freedomtan/aarch64-bare-metal-qemu).
    * Directly using UARTDR(UART Data Register) to send out the characters.
  * [ARM926 interrupts in QEMU](https://balau82.wordpress.com/2012/04/15/arm926-interrupts-in-qemu/)
    * The basic uart interrupt example
  * [FreeRTOS-GCC-ARM926ejs](https://github.com/jkovacic/FreeRTOS-GCC-ARM926ejs)
    * [ARM9EJ-S Technical Reference Manual - DDI0222](http://infocenter.arm.com/help/topic/com.arm.doc.ddi0222b/DDI0222.pdf)
    * [Building Bare-Metal ARM Systems with GNU: Part 2](https://www.embedded.com/design/mcus-processors-and-socs/4026075/Building-Bare-Metal-ARM-Systems-with-GNU-Part-2)    
  * [raspberrypi](https://github.com/eggman/raspberrypi)
  * [sample-tsk-sw](https://github.com/takeharukato/sample-tsk-sw)
  * [armv8-bare-metal](https://github.com/NienfengYao/armv8-bare-metal)
    * My study, including the basic booting, gic and timer
  * FreeRTOSv10.0.1/FreeRTOS/Demo/CORTEX_A53_64-bit_UltraScale_MPSoC
* QEMU
  * [QEMU version 2.12.50 User Documentation](https://qemu.weilnetz.de/doc/qemu-doc.html)
  * [virt.c][https://github.com/qemu/qemu/blob/master/hw/arm/virt.c]
* Makefile
  * [Makefile範例教學](http://maxubuntu.blogspot.com/2010/02/makefile.html)
  * [GNU 的連結工具 (ld, nm, objdump, ar)](http://sp1.wikidot.com/gnulinker)
  * [GCC Command-Line Options](http://tigcc.ticalc.org/doc/comopts.html)
  * [LD Index](https://sourceware.org/binutils/docs/ld/LD-Index.html#LD-Index)
* FreeRTOS
  * Start
    * [Creating a New FreeRTOS Project](https://www.freertos.org/Creating-a-new-FreeRTOS-project.html)
    * [FreeRTOS Quick Start Guide](https://www.freertos.org/FreeRTOS-quick-start-guide.html)
    * [Getting Started with Simple FreeRTOS Projects](https://www.freertos.org/simple-freertos-demos.html)
    * [Hardware independent FreeRTOS example](https://www.freertos.org/Hardware-independent-RTOS-example.html)
    * [FreeRTOS Tutorial](http://socialledge.com/sjsu/index.php/FreeRTOS_Tutorial)
    * [Coding Standard and Style Guide](https://www.freertos.org/FreeRTOS-Coding-Standard-and-Style-Guide.html)
  * Memory
    * [Memory Management](https://www.freertos.org/a00111.html)
    * [Static Vs Dynamic Memory Allocation](https://www.freertos.org/Static_Vs_Dynamic_Memory_Allocation.html)
    * [Statically Allocated FreeRTOS Reference Project](https://www.freertos.org/freertos-static-allocation-demo.html)
  * GIC
    * [That incorporate a Generic Interrupt Controller (GIC)](https://www.freertos.org/Using-FreeRTOS-on-Cortex-A-Embedded-Processors.html)
    * [淺談優先權，從ARM Cortex-M到FreeRTOS設定](http://opass.logdown.com/posts/248297-talking-about-the-priority-from-the-arm-set-cortex-m-to-freertos)
  * [FreeRTOS Tutorial](http://socialledge.com/sjsu/index.php/FreeRTOS_Tutorial)
* U-Boot
  * [U-Boot on QEMU's 'virt' machine on ARM & AArch64](https://github.com/u-boot/u-boot/blob/master/doc/README.qemu-arm)
  * [What is the difference between ELF files and bin files?](https://stackoverflow.com/questions/2427011/what-is-the-difference-between-elf-files-and-bin-files?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)
  * [U-BOOT-2016.07移植 (第一篇) 初步分析](http://www.itread01.com/articles/1476615343.html)
* GDB
  * [GNU GDB Debugger Command Cheat Sheet](http://www.yolinux.com/TUTORIALS/GDB-Commands.html)
  * [Debugging with GDB （入門篇）](http://www.study-area.org/goldencat/debug.htm)
  * [GDB Debugging ARM U-Boot on QEMU](http://winfred-lu.blogspot.com/2011/12/arm-u-boot-on-qemu.html)
  * [Use Qemu GDB to forcely debug Linux early boot process ](https://mudongliang.github.io/2017/09/21/use-qemu-gdb-to-forcely-debug-linux-early-boot-process.html)
  * [how can one see content of stack with gdb](https://stackoverflow.com/questions/7848771/how-can-one-see-content-of-stack-with-gdb)
  * [10.6 Examining Memory](https://sourceware.org/gdb/onlinedocs/gdb/Memory.html)
* ARM
  * [iOS开发同学的arm64汇编入门](https://blog.cnbluebox.com/blog/2017/07/24/arm64-start/)
  * [Arm® Compiler armasm User Guide](http://www.keil.com/support/man/docs/armclang_asm/armclang_asm_chunk708094578.htm)
  * [Application Note Bare-metal Boot Code for ARMv8-A Processors Version 1.0](http://infocenter.arm.com/help/topic/com.arm.doc.dai0527a/DAI0527A_baremetal_boot_code_for_ARMv8_A_processors.pdf)
  * ARM® Architecture Reference Manual ARMv8, for ARMv8-A architecture profile Beta
  * ARM® Cortex®-A57 MPCore™ Processor Revision: r1p0 Technical Reference Manual
  * ARM® Cortex®-A Series Version: 1.0 Programmer’s Guide for ARMv8-A
  * ARM® Generic Interrupt Controller Architecture Specification GIC architecture version 3.0 and version 4.0
* Compile
  * [GNU 的連結工具 (ld, nm, objdump, ar)](http://sp1.wikidot.com/gnulinker)
  * Makefile
    * [Makefile的賦值運算符(=, :=, +=, ?=)](http://dannysun-unknown.blogspot.com/2015/03/makefile.html)
  * GCC
    * [GCC Command-Line Options](http://tigcc.ticalc.org/doc/comopts.html)
    * Weak symbol
      * [弱符號 - 維基百科](https://zh.wikipedia.org/wiki/%E5%BC%B1%E7%AC%A6%E5%8F%B7)
      * [Weak references and definitions](http://www.keil.com/support/man/docs/armclang_link/armclang_link_pge1362065917715.htm)
  * Assembler
    * [Writing ARM Assembly Language](http://www.keil.com/support/man/docs/armasm/armasm_dom1359731144635.htm)
    * [ARM組語備忘錄](https://myao0730.blogspot.com/2015/09/arm-aapcs-def-procedure-call-standard.html)
    * [Using as](https://sourceware.org/binutils/docs/as/index.html#SEC_Contents)
* printf()
  * [Write your own printf() function in c](http://www.firmcodes.com/write-printf-function-c/)
  * [Wiki: stdarg.h](https://zh.wikipedia.org/wiki/Stdarg.h)
  * [printf-stdarg.c](https://github.com/atgreen/FreeRTOS/blob/master/Demo/CORTEX_STM32F103_Primer_GCC/printf-stdarg.c)
  
