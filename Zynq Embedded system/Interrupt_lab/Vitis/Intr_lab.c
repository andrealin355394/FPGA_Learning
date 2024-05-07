#include "xparameters.h"
#include "xgpiops.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xplatform_info.h"
#include <xil_printf.h>
#include "sleep.h"

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


#define GPIO_DEVICE_ID		XPAR_XGPIOPS_0_DEVICE_ID
#define INTC_DEVICE_ID		XPAR_SCUGIC_SINGLE_DEVICE_ID
#define GPIO_INTERRUPT_ID	XPAR_XGPIOPS_0_INTR

int SetupInterruptSystem(XScuGic *Intc, XGpioPs *Gpio, u16 GpioIntrId);
void IntrHandler();
//void IntrHandler(void *CallBackRef, u32 Bank, u32 Status);
 XScuGic Intc; /* The Instance of the Interrupt Controller Driver */


 XGpioPs Gpio; /* The Instance of the GPIO Driver */
 XGpioPs_Config *ConfigPtr;




int main()
{
	int Status;
    print("GPIO Interrupt Example Test \r\n");
    u32 Readdata;

        //refer tool id, find tool ID
        ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
    	print("GPIO_config Initialize Successfully \n\r");
    	/* Initialize the GPIO driver. */
    	Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr,ConfigPtr->BaseAddr);
    	if (Status != XST_SUCCESS) {
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


    	/*
    	 * Setup the interrupts such that interrupt processing can occur. If
    	 * an error occurs then exit.
    	 */
//	xil_printf("GPIO Interrupt Example Test \r\n");
//	SetupInterruptSystem(&Intc, &Gpio, GPIO_INTERRUPT_ID);
//	xil_printf("SetupInterruptSystem Successfully  \r\n");

	while(1){
		Readdata = 	XGpioPs_ReadPin(&Gpio, PL_EMIO);

		if(Readdata == 1){
			xil_printf("Open InterruptSystem\r\n");
			sleep(1);
			SetupInterruptSystem(&Intc, &Gpio, GPIO_INTERRUPT_ID);
			xil_printf("SetupInterruptSystem Successfully  \r\n");
		}

		XGpioPs_WritePin(&Gpio, PS_LED1, High);
		xil_printf(" LED is Light \r\n");
		sleep(1);
	}
    return 0;
}

int SetupInterruptSystem(XScuGic *GicInstancePtr, XGpioPs *Gpio,u16 GpioIntrId){
	XScuGic_Config *IntcConfig; /* Instance of the interrupt controller */

	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
//	xil_printf("XScuGic_LookupConfig Successfully  \r\n");
	XScuGic_CfgInitialize(GicInstancePtr, IntcConfig,IntcConfig->CpuBaseAddress);
//	xil_printf("XScuGic_CfgInitialize Successfully  \r\n");
//	xil_printf("=================================\r\n");

	/*
	 * Connect the interrupt controller interrupt handler to the hardware interrupt handling logic in the processor.
	 */
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,(Xil_ExceptionHandler)XScuGic_InterruptHandler, GicInstancePtr);
	/* Enable interrupts in the Processor. */
	Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);

//	print("Xil_ExceptionInit Successfully\r\n");
	/*
	 * Connect the device driver handler that will be called when an
	 * interrupt for the device occurs, the handler defined above performs
	 * the specific interrupt processing for the device.
	 */
	XScuGic_Connect(GicInstancePtr, GpioIntrId,(Xil_ExceptionHandler)IntrHandler,(void *)Gpio);
	/* Set the handler for gpio interrupts. */
//	XGpioPs_SetCallbackHandler(Gpio, (void *)Gpio, IntrHandler);

//	print("XScuGic_Connect Successfully\r\n");
	/* Enable the interrupt for the GPIO device. */
	XScuGic_Enable(GicInstancePtr, GpioIntrId);

//	print("XScuGic_Enable Successfully\r\n");
	/* Enable falling edge interrupts for all the pins in GPIO bank. */
//	XGpioPs_SetIntrType(Gpio, GPIO_BANK, 0x00, 0xFFFFFFFF, 0x00);

	/* Enable falling edge interrupts for all the pins in GPIO */
	XGpioPs_SetIntrTypePin(Gpio, PL_EMIO , XGPIOPS_IRQ_TYPE_EDGE_FALLING);

//	print("XGpioPs_SetIntrTypePin Successfully\r\n");
	/* Enable the GPIO interrupts of GPIO Bank. */
//	XGpioPs_IntrEnable(Gpio, GPIO_BANK, (1 << Input_Bank_Pin));

	/* Enable the GPIO interrupts of GPIO. */
	XGpioPs_IntrEnablePin(Gpio,PL_EMIO);
//	print("XGpioPs_IntrEnablePin Successfully\r\n");

	return XST_SUCCESS;
}

void IntrHandler(){
	print("Interrupt Successfully\r\n");
	XGpioPs_WritePin(&Gpio, PS_LED1, Low);
	print("LED is Off\r\n");
	sleep(3);
	XGpioPs_IntrDisablePin(&Gpio, PL_EMIO);
	print("Disable Interrupt Successfully\r\n");
}
