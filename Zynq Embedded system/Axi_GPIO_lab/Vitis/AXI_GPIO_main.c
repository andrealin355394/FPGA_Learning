#include "xparameters.h"
#include "xgpio.h"
#include "xil_exception.h"
#include <stdio.h>
#include "xscugic.h"
#include "xil_printf.h"
#include "xgpiops.h"
#include "sleep.h"

#define GPIO_DEVICE_ID		XPAR_XGPIOPS_0_DEVICE_ID			//ps gpio
#define INTC_DEVICE_ID		XPAR_SCUGIC_SINGLE_DEVICE_ID		//ps intr
#define GPIO_INTERRUPT_ID	XPAR_XGPIOPS_0_INTR  				//PS intr #52
#define INTC_HANDLER	XScuGic_InterruptHandler
#define AXI_GPIO_DEVICE_ID		XPAR_GPIO_0_DEVICE_ID			//axi gpio
#define INTC_GPIO_INTERRUPT_ID	XPAR_FABRIC_AXI_GPIO_IP2INTC_IRPT_INTR		//axi intr #61
#define INTC		XScuGic

#define gpio_input 		0
#define gpio_output 	1
//PS MIO
#define PS_LED1 		10
#define PL_EMIO			54
#define Enable			1
#define disable			0
#define High			1
#define Low				0
#define LED_DELAY       1000000

// axi GPIO channel 1
#define GPIO_CHANNEL1		1

#define BUTTON_CHANNEL	 2	/* Channel 1 of the GPIO Device */
#define LED_CHANNEL	 1	/* Channel 2 of the GPIO Device */

#define LED1 		0x01
#define LED2 		0x02
#define LED3 		0x04
#define LED4 		0x08
#define LED_FULL	0x0F
#define BTN1 		0x00
#define BTN2 		0x01

int key_press;
int led_value = 0x0F;


int SetupInterruptSystem(XScuGic *GicInstancePtr,XGpio *AXI_Gpio,u16 AXI_GpioIntrId);
void IntrHandler();


XScuGic Intc; /* The Instance of the Interrupt Controller Driver */
XScuGic_Config *IntcConfig; /* Instance of the interrupt controller */

XGpioPs Gpio; /* The Instance of the GPIO Driver */
XGpioPs_Config *ConfigPtr;

XGpio AXI_Gpio;
INTC Intc; /* The Instance of the Interrupt Controller Driver */


int main(){
	xil_printf("AXI GPIO INTERRUPT TEST");


	/* Initialize the PS_GPIO driver. */
	ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
	XGpioPs_CfgInitialize(&Gpio, ConfigPtr,ConfigPtr->BaseAddr);
	xil_printf("Initialize the PS_GPIO driver Successfully\n\r");

	/* Initialize the AXI_GPIO driver. find the xgpio.h */
	XGpio_Initialize(&AXI_Gpio, AXI_GPIO_DEVICE_ID);
	xil_printf("Initialize the AXI_GPIO driver Successfully\n\r");

	//Set the direction for the PS_pin to be output and
	XGpioPs_SetDirectionPin(&Gpio, PS_LED1, gpio_output);
	XGpioPs_SetOutputEnablePin(&Gpio, PS_LED1, Enable);
	xil_printf("PS_pin setting AXI_GPIO driver Successfully\n\r");

	//set the AXI_GPIO . refer the xgpio.h
//	XGpio_SetDataDirection(&AXI_Gpio, LED_CHANNEL,0x01);
//	xil_printf("set XGpio_SetDataDirection Successfully\n\r");




	SetupInterruptSystem(&Intc, &AXI_Gpio, INTC_GPIO_INTERRUPT_ID);
	xil_printf("SetupInterruptSystem Successfully  \r\n");



	while(1){
//		xil_printf("SetupInterruptSystem Successfully ,key_press = %d\r\n",key_press);
		if(key_press){
			led_value = ~led_value;
			key_press = 0;
			//clear the interrupt statue
			XGpio_DiscreteWrite(&AXI_Gpio, LED_CHANNEL, led_value);
			xil_printf("Light change statue Successfully  \r\n");

			sleep(1);
			XGpio_InterruptClear(&AXI_Gpio, BUTTON_CHANNEL);
			xil_printf("XGpio_InterruptClear Successfully  \r\n");
			//enable interrupt
			XGpio_InterruptEnable(&AXI_Gpio, BUTTON_CHANNEL);
		}

	}
	return 0;
}


int SetupInterruptSystem(XScuGic *GicInstancePtr,XGpio *AXI_Gpio,u16 AXI_GpioIntrId)
{

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
	XScuGic_Connect(GicInstancePtr, AXI_GpioIntrId,(Xil_ExceptionHandler)IntrHandler,(void *)AXI_Gpio);
	/* Set the handler for AXI_Gpio interrupts. */
//	XGpioPs_SetCallbackHandler(AXI_Gpio, (void *)Gpio, IntrHandler);

//	print("XScuGic_Connect Successfully\r\n");
	/* Enable the interrupt for the AXI_Gpio device. */
	XScuGic_Enable(GicInstancePtr, AXI_GpioIntrId);

//	print("XScuGic_Enable Successfully\r\n");
	/* Enable falling edge interrupts for all the pins in GPIO bank. */
//	XGpioPs_SetIntrType(AXI_Gpio, GPIO_BANK, 0x00, 0xFFFFFFFF, 0x00);


	/*
	 * Sets the interrupt priority and trigger type for the specificd IRQ source.
	 * interrupt type are High 0x01
	 * 0xA0 set priority the interrupt
	 */

	XScuGic_SetPriorityTriggerType(GicInstancePtr, AXI_GpioIntrId,0xA0, 0x01);

	/*
	 * Enable the AXI GPIO channel interrupts so that push button can be
	 * detected and enable interrupts for the AXI GPIO device
	 */
	XGpio_InterruptGlobalEnable(AXI_Gpio);
	XGpio_InterruptEnable(AXI_Gpio, BUTTON_CHANNEL);

	return XST_SUCCESS;
}


void IntrHandler(){
	key_press = 1;
	print("Interrupt Successfully\r\n");
	sleep(3);
	//disable interrupt
	XGpio_InterruptDisable(&AXI_Gpio, BUTTON_CHANNEL);
	print("Disable Interrupt Successfully\r\n");
}

