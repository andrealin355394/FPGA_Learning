#include "xparameters.h"
//#include "xgpio.h"
#include "xil_exception.h"
#include <stdio.h>
#include "xscugic.h"
#include "xil_printf.h"
//#include "xgpiops.h"
#include "sleep.h"
#include "breath_led.h"
#include "xil_io.h"

#define LED_IP_BASEADDR			XPAR_BREATH_LED_0_S00_AXI_BASEADDR
#define LED_IP_SLV_REG0			BREATH_LED_S00_AXI_SLV_REG0_OFFSET

#define BREATH_LED_IP_S00_AXI_SLV_REG0_OFFSET 		0
#define BREATH_LED_IP_S00_AXI_SLV_REG1_OFFSET 		4
#define BREATH_LED_IP_S00_AXI_SLV_REG2_OFFSET 		8
#define BREATH_LED_IP_S00_AXI_SLV_REG3_OFFSET 		12

#define High			0x00000001
#define	Low				0


int main()
{
	xil_printf("Custom IP AXI ctrl test\n\r");
//	BREATH_LED_IP_mWriteReg(BaseAddress, RegOffset, Data)

	while(1){
		xil_printf("breath_led  \n\r");
		BREATH_LED_mWriteReg(LED_IP_BASEADDR,LED_IP_SLV_REG0,High);
		sleep(5);
		BREATH_LED_mWriteReg(LED_IP_BASEADDR,LED_IP_SLV_REG0,Low);
	}
    return 0;
}
