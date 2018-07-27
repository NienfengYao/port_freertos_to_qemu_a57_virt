/*
 * FreeRTOS Kernel V10.0.1
 * Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * http://www.FreeRTOS.org
 * http://aws.amazon.com/freertos
 *
 * 1 tab == 4 spaces!
 */

/* FreeRTOS includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "cpu.h"
#include "uart.h"

static uint32_t cntfrq;     /* System frequency */

/* Timer used to generate the tick interrupt. */
void vConfigureTickInterrupt( void )
{
	uint32_t val;
	uint64_t ticks, current_cnt;

    uart_puts("CurrentEL = ");
	val = raw_read_current_el();
	uart_puthex(val);

    uart_puts("\nRVBAR_EL1 = ");
	val = raw_read_rvbar_el1();
	uart_puthex(val);

    uart_puts("\nVBAR_EL1 = ");
	val = raw_read_vbar_el1();
	uart_puthex(val);

    uart_puts("\nDAIF = ");
	val = raw_read_daif();
	uart_puthex(val);

	// Disable the timer
	disable_cntv();
    uart_puts("\nDisable the timer, CNTV_CTL_EL0 = ");
	val = raw_read_cntv_ctl();
	uart_puthex(val);
    uart_puts("\nSystem Frequency: CNTFRQ_EL0 = ");
	cntfrq = raw_read_cntfrq_el0();
	uart_puthex(cntfrq);

	// Next timer IRQ is after n sec(s).
	ticks = 1 * cntfrq;
	// Get value of the current timer
	current_cnt = raw_read_cntvct_el0();
    uart_puts("\nCurrent counter: CNTVCT_EL0 = ");
	uart_puthex(current_cnt);
	// Set the interrupt in Current Time + TimerTick
	raw_write_cntv_cval_el0(current_cnt + ticks);
    uart_puts("\nAssert Timer IRQ after 1 sec: CNTV_CVAL_EL0 = ");
	val = raw_read_cntv_cval_el0();
	uart_puthex(val);

	// Enable the timer
	enable_cntv();
    uart_puts("\nEnable the timer, CNTV_CTL_EL0 = ");
	val = raw_read_cntv_ctl();
	uart_puthex(val);

	// Enable IRQ 
	enable_irq();
    uart_puts("\nEnable IRQ, DAIF = ");
	val = raw_read_daif();
	uart_puthex(val);
    uart_puts("\n");

}
/*-----------------------------------------------------------*/

void vClearTickInterrupt( void )
{
	uint64_t ticks, current_cnt;
	uint32_t val;

    uart_puts("timer_handler: \n");

	// Disable the timer
	disable_cntv();
    uart_puts("\tDisable the timer, CNTV_CTL_EL0 = ");
	val = raw_read_cntv_ctl();
	uart_puthex(val);
	gicd_clear_pending(TIMER_IRQ);
    uart_puts("\n\tSystem Frequency: CNTFRQ_EL0 = ");
	uart_puthex(cntfrq);

	// Next timer IRQ is after n sec.
	ticks = 1 * cntfrq;
	// Get value of the current timer
	current_cnt = raw_read_cntvct_el0();
    uart_puts("\n\tCurrent counter: CNTVCT_EL0 = ");
	uart_puthex(current_cnt);
	// Set the interrupt in Current Time + TimerTick
	raw_write_cntv_cval_el0(current_cnt + ticks);
	val = raw_read_cntv_cval_el0();
	uart_puthex(val);

	// Enable the timer
	enable_cntv();
    uart_puts("\n\tEnable the timer, CNTV_CTL_EL0 = ");
	val = raw_read_cntv_ctl();
	uart_puthex(val);
    uart_puts("\n");
}
/*-----------------------------------------------------------*/

void vApplicationIRQHandler( uint32_t ulICCIAR )
{
	uint32_t ulInterruptID;

    uart_puts("\nvApplicationIRQHandler: ");
	uart_puthex(ulICCIAR);
    uart_puts("\n");

	/* Interrupts cannot be re-enabled until the source of the interrupt is
	cleared. The ID of the interrupt is obtained by bitwise ANDing the ICCIAR
	value with 0x3FF. */
	ulInterruptID = ulICCIAR & 0x3FFUL;

	/* call handler function */
	if( ulInterruptID == TIMER_IRQ) {
		/* Generic Timer */
		uart_puts("\nvApplicationIRQHandler: Timer IRQ\n");
		FreeRTOS_Tick_Handler();
	}else{
		uart_puts("\nvApplicationIRQHandler: IRQ happend (except timer)\n");
	}
}
