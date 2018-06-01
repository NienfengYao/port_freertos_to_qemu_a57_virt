/*OUTPUT_ARCH(arm)*/
ENTRY(_Reset)
/*ENTRY(_start)*/

SECTIONS
{
	. = 0x40000000;
	.text : 
	{
		*(.startup)
		*(.text)
	}
	. = ALIGN(32);
										
	.data : 
	{
		*(.data)
	}
	. = ALIGN(32);

	__bss_start__	= .;
	.bss : 
	{
		*(.bss)
	}
	__bss_end__ = .;
	. = ALIGN(32);

	. = . + 0x1000; /* 4kB of stack memory */
	stack_top = .;
}
