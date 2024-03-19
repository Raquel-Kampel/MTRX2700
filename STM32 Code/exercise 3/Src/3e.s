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

	@ B reading



transmitting:

	LDR R0, =USART1		@ load USART1

	BL rx_loop			@ read from terminal

	LDR R0, =UART4		@ load UART4

	BL return_after_tx	@ transmit to other board (via UART4)

	B part_e_main		@ loop back to reading


reading:

	LDR R0, =UART4 		@ load UART4

	BL rx_loop			@ read from other board

	LDR R0, =USART1		@ load USART1

	BL return_after_tx	@ transmit to terminal

	B part_e_main		@ loop back to reading
