/* Standard includes. */
#include <stdio.h>

/* Scheduler include files. */
#include "FreeRTOS.h"
#include "task.h"

/* driver includes. */
#include "uart.h"

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
		//vTaskDelay(1000);
	}
}

int main(void)
{
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
