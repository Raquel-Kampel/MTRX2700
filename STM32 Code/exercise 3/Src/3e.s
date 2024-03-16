.syntax unified
.thumb

#include "definitions.s"


.data

.text


part_e_main:

	@ Get pointers to the buffer and buffer size (62)
	LDR R1, =incoming_buffer
	LDR R7, =buffer_size
	LDRB R7, [R7]	@ de-reference R7
	MOV R8, #0x00	@ counter for how many letters received

	@ comment out for transmitting or receiving

	B transmitting

	@ B receiving



transmitting:

	LDR R0, =USART1	@ load USART1

	@ read in characters from the command line
	BL rx_loop

	@ transmit characters
	BL return_after_tx

	B part_e_main


receiving:

	LDR R0, =UART4 @ load UART4

	@ read in characters
	BL rx_loop

	B part_e_main
