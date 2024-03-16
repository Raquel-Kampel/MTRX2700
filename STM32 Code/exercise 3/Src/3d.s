.syntax unified
.thumb

#include "definitions.s"


.data

.text


part_d_main:

	LDR R0, =USART1				@ load USART1
	LDR R1, =incoming_buffer	@ buffer for storing string read in
	LDR R7, =buffer_size		@ size of buffer
	LDRB R7, [R7]				@ de-reference R7
	MOV R8, #0x00				@ counter for how many letters received

	@ branch to the read function (in 3b.s)
	BL rx_loop

	@ branch to the transmit function (in 3a.s)
	BL return_after_tx

	B part_d_main
