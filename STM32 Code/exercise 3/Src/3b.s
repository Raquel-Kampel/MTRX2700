.syntax unified
.thumb

#include "definitions.s"

.data


.align
incoming_buffer: .space 62	@ buffer for string to be read (max 62 characters)
incoming_counter: .byte 62	@ counter for number of characters read


.text


part_b_main:

	@ Get pointers to the buffer and counter memory areas
	LDR R1, =incoming_buffer
	LDR R7, =incoming_counter

	@ dereference the memory for the maximum buffer size, store it in R7
	LDRB R7, [R7]

	@ Keep a pointer that counts how many bytes have been received
	MOV R8, #0x00


rx_loop:

	LDR R0, =UART @ the base address for the register to set up UART
	LDR R2, [R0, USART_ISR] @ load the status of the UART

	TST R2, 1 << UART_ORE | 1 << UART_FE  @ 'AND' the current status with the bit mask that we are interested in
						   @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	BNE clear_error

	TST R2, 1 << UART_RXNE @ 'AND' the current status with the bit mask that we are interested in
							  @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	BEQ rx_loop @ loop back to check status again if the flag indicates there is no byte waiting

	LDRB R3, [R0, USART_RDR] @ load the lowest byte (RDR bits [0:7] for an 8 bit read)

	CMP R3, #0x24 @ check if the '$' symbol has been reached indicating to stop reading

	BEQ finish_loop

	STRB R3, [R1, R8]
	ADD R8, #1

	CMP R7, R8
	BGT no_reset
	MOV R8, #0


no_reset:

	@ load the status of the UART
	LDR R2, [R0, USART_RQR]
	ORR R2, 1 << UART_RXFRQ
	STR R2, [R0, USART_RQR]

	BGT rx_loop


clear_error:

	@ Clear the overrun/frame error flag in the register USART_ICR (see page 897)
	LDR R2, [R0, USART_ICR]
	ORR R2, 1 << UART_ORECF | 1 << UART_FECF @ clear the flags (by setting flags to 1)
	STR R2, [R0, USART_ICR]
	B rx_loop


finish_loop:

	B finish_loop
