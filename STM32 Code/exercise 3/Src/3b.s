.syntax unified
.thumb

#include "definitions.s"

.data

.align
incoming_buffer: .space 62	@ buffer for string to be read (max 62 characters)
buffer_size: .byte 62		@ buffer size


.text


part_b_main:

	LDR R0, =USART1				@ load USART1
	LDR R1, =incoming_buffer	@ buffer for storing string read in
	LDR R7, =buffer_size		@ size of buffer
	LDRB R7, [R7]				@ de-reference R7
	MOV R8, #0x00				@ counter for how many letters received

	@ start reading
	BL rx_loop

	@ enter infinite loop when finished
	B finish_loop



rx_loop:

	@ load UART status register
	LDR R3, [R0, USART_ISR]

	@ check for overrun or frame errors
	//TST R3, 1 << UART_ORE | 1 << UART_FE
	//BNE clear_error

	@ check if there is a byte ready to read
	TST R3, 1 << UART_RXNE
	BEQ rx_loop

	@ store byte in the buffer and increment buffer position
	LDRB R3, [R0, USART_RDR]
	STRB R3, [R1, R8]
	ADD R8, #1

	@ load current byte, check for carriage return (enter key)
	CMP R3, #0x0D
	BEQ finish_read

	@ if R5 is one, only transmit one byte at a time
	CMP R5, #1
	BEQ finish_read

	@ check if transmission exceeds buffer size
	CMP R7, R8
	BGT no_reset
	MOV R8, #0 @ reset the buffer position


no_reset:

	@ refreshes the RXNE flag (prevents overrun error)
	LDR R3, [R0, USART_RQR]
	ORR R3, 1 << UART_RXFRQ
	STR R3, [R0, USART_RQR]

	BGT rx_loop


/*
clear_error:

	@ Clear the overrun/frame error flags by setting them to 1
	LDR R3, [R0, USART_ICR]
	ORR R3, 1 << UART_ORECF | 1 << UART_FECF
	STR R3, [R0, USART_ICR]

	B rx_loop
*/


finish_read:

	@ reset buffer position
	MOV R8, #0

	BX LR


finish_loop:

	B finish_loop
