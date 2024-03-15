.syntax unified
.thumb

#include "definitions.s"


.data

.text


part_d_main:

	@ Get pointers to the buffer and buffer size (62)
	LDR R1, =incoming_buffer
	LDR R7, =buffer_size
	LDRB R7, [R7]	@ de-reference R7
	MOV R8, #0x00	@ counter for how many letters received
	LDR R0, =USART1	@ load USART1

	@ branch to the read function (in 3b.s)
	BL rx_loop

	@ branch to the transmit function (in 3a.s)
	BL store_position

	B part_d_main
