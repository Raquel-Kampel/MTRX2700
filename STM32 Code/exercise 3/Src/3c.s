.syntax unified
.thumb

#include "definitions.s"


.data

.text


part_c_main:

	@ change the clock to PLL and set to 48 MHz (6x speed)
	BL change_clock_speed

	@ change baud rate value for the different clock speed
	MOV R1, #0x1A1 @ value calcualted for setting baud rate to 115200
	LDR R0, =UART
	STRH R1, [R0, #USART_BRR]

	@ branch to 3a (transmitting with button) with the new clock speed
	B part_a_main
