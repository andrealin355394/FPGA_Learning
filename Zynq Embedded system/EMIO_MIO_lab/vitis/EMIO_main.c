#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xstatus.h"
#include "xgpiops.h"
#include "sleep.h"

#define GPIO_DEVICE_ID		XPAR_XGPIOPS_0_DEVICE_ID
#define gpio_input 		0
#define gpio_output 	1
//PS MIO
#define PS_LED1 		10
#define PS_MIO8         8
//PL EMIO
#define PL_EMIO			54
#define Enable			1
#define disable			0
#define High			1
#define Low				0
#define LED_DELAY       1000000

XGpioPs Gpio;	/* The driver instance for GPIO Device. */
XGpioPs_Config *ConfigPtr;

int main()
{

    print("GPIO MIO TEST \n\r");

    u32 Readdata;

    //refer tool id, find tool ID
    int status;
    ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
	print("GPIO_config Initialize Successfully \n\r");
	/* Initialize the GPIO driver. */
	status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr,ConfigPtr->BaseAddr);
	if (status != XST_SUCCESS) {
		print("cfg_status Initialize failure \n\r");
		return XST_FAILURE;
	}
	print("cfg_status Initialize Successfully \n\r");


	/*
	 * Set the direction for the pin to be output and
	 */

	XGpioPs_SetDirectionPin(&Gpio, PS_LED1, gpio_output);
	XGpioPs_SetDirectionPin(&Gpio, PL_EMIO, gpio_input);
	 /*
	  * Enable the Output enable for the LED Pin.
	  */
	XGpioPs_SetOutputEnablePin(&Gpio, PS_LED1, Enable);

	/* Set the GPIO output */

	print("Set the GPIO output Successfully \n\r");



	while(1){
		Readdata = 	XGpioPs_ReadPin(&Gpio, PL_EMIO);
		XGpioPs_WritePin(&Gpio, PS_LED1, Readdata);
		printf("LED, statue is %d \n\r",Readdata);
		sleep(1);
	}
    return 0;
	}
