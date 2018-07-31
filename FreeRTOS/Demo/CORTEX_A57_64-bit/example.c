#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "semphr.h"
#include "uart.h"
#include "example.h"


/* Queue Example */
static xQueueHandle Global_Queue_Handle = 0;

void sender_task(void *p)
{
	int i=0;
	while(1){
		printf("Send %d to receiver task\n", i);
		if(!xQueueSend(Global_Queue_Handle, &i, 1000)){
			printf("Failed to send to queue.\n");
		}
		i++;
		vTaskDelay(3000);
	}
}

void receive_task(void *p)
{
	int rx_int=0;
	while(1){
		if(xQueueReceive(Global_Queue_Handle, &rx_int, 1000)){
			printf("Received %d \n", rx_int);
		}else{
			printf("Failed to receive from queue.\n");
		}
	}
}

void test_queue(void)
{
	Global_Queue_Handle = xQueueCreate(3, sizeof(int));

	/* Create Tasks */
	xTaskCreate(sender_task, "tx", 1024, NULL, 1, NULL);
	xTaskCreate(receive_task, "rx", 1024, NULL, 1, NULL);
}

/* Mutex Example */
static xSemaphoreHandle gatekeeper = 0;
static void access_precious_resource(void){}

void user_1(void *p)
{
	while(1){
		if(xSemaphoreTake(gatekeeper, 1000)){
			printf("User 1 got access\n");
			access_precious_resource();
			xSemaphoreGive(gatekeeper);
		}else{
			printf("User 1 failed to get access within 1 second.\n");
		}
	vTaskDelay(1000);
	}
}

void user_2(void *p)
{
	while(1){
		if(xSemaphoreTake(gatekeeper, 1000)){
			printf("User 2 got access\n");
			access_precious_resource();
			xSemaphoreGive(gatekeeper);
		}else{
			printf("User 2 failed to get access within 1 second.\n");
		}
	vTaskDelay(1000);
	}
}

void test_semaphore(void)
{
	gatekeeper = xSemaphoreCreateMutex();

	/* Create Tasks */
	xTaskCreate(user_1, "t1", 1024, NULL, 1, NULL);
	xTaskCreate(user_2, "t2", 1024, NULL, 1, NULL);
}

/* Binary Semaphore Example */
static xSemaphoreHandle employee_signal = 0;
static void	employee_task(){}

void boss(void *p)
{
	while(1){
		printf("Boss give the signal.\n");
		xSemaphoreGive(employee_signal);
		printf("Boss finished givin the signal.\n");
		vTaskDelay(2000);
	}
}
void employee(void *p)
{
	while(1){
		if(xSemaphoreTake(employee_signal, portMAX_DELAY)){
			employee_task();
			printf("Employee has finished its task.\n");
		}
	}
}

void test_binary_semaphore(void)
{
	employee_signal = xSemaphoreCreateBinary();

	/* Create Tasks */
	/* Change the priority will affect the working flow */
	xTaskCreate(boss, "boss", 1024, NULL, 1, NULL);
	//xTaskCreate(employee, "employee", 1024, NULL, 1, NULL);
	xTaskCreate(employee, "employee", 1024, NULL, 2, NULL);
}
