/* Standard includes. */
#include <stdio.h>

/* Scheduler include files. */
#include "FreeRTOS.h"
#include "task.h"

/* board include files. */
#include "board.h"
#include "gic_v3.h"

/* driver includes. */
#include "uart.h"

/* Configure the hardware as necessary */
static void prvSetupHardware( void );

static void prvSetupHardware( void )
{
	/* Ensure no interrupts execute while the scheduler is in an inconsistent
	state.  Interrupts are automatically enabled when the scheduler is
	started. */
	portDISABLE_INTERRUPTS();

	/* Initialize the GIC, including config of partial timer irq */
	gic_v3_initialize();
}

void vMainAssertCalled( const char *pcFileName, uint32_t ulLineNumber )
{
	//xil_printf( "ASSERT!  Line %lu of file %s\r\n", ulLineNumber, pcFileName );
	uart_puts("ASSERT!  Line ");
	uart_puthex(ulLineNumber);
	uart_puts(" of file ");
	uart_puts( pcFileName );
	uart_puts("\n" );
	taskENTER_CRITICAL();
	for( ;; );
}

void hello_world_task(void *p)
{
	while(1) {
		uart_puts("Hello World Task!");
		vTaskDelay(1);
	}
}

int main(void)
{
	/* Configure the hardware ready to run */
	prvSetupHardware();

	uart_puts("Hello World!\n");
	//configASSERT(0);

	/* Create Tasks */
	uart_puts("1!\n");
	xTaskCreate(hello_world_task, "hello_task", 2048, 0, 1, 0);
	uart_puts("2!\n");

	/* Start the scheduler */	
	vTaskStartScheduler();
	uart_puts("3!\n");

	return -1;
}
