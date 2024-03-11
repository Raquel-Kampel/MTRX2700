.syntax unified
.thumb

#include "definitions.s"


.data


.text


part_d_main:

	LDR R1, =incoming_buffer
	LDR R7, =incoming_counter

	@ dereference the memory for the maximum buffer size, store it in R7
	LDRB R7, [R7]

	@ Keep a pointer that counts how many bytes have been received
	MOV R8, #0x00


read_loop:

	LDR R0, =UART @ the base address for the register to set up UART
	LDR R2, [R0, USART_ISR] @ load the status of the UART

	TST R2, 1 << UART_ORE | 1 << UART_FE  @ 'AND' the current status with the bit mask that we are interested in
						   @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	BNE clear_error_d

	TST R2, 1 << UART_RXNE @ 'AND' the current status with the bit mask that we are interested in
							  @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	BEQ read_loop @ loop back to check status again if the flag indicates there is no byte waiting

	LDRB R3, [R0, USART_RDR] @ load the lowest byte (RDR bits [0:7] for an 8 bit read)
	STRB R3, [R1, R8]
	ADD R8, #1

	CMP R3, #0x24 @ check if the '$' symbol has been reached indicating to stop reading
	BEQ transmit_loop

	CMP R7, R8
	BGT no_reset_d
	MOV R8, #0


no_reset_d:

	@ load the status of the UART
	LDR R2, [R0, USART_RQR]
	ORR R2, 1 << UART_RXFRQ
	STR R2, [R0, USART_RQR]

	BGT read_loop


clear_error_d:

	@ Clear the overrun/frame error flag in the register USART_ICR (see page 897)
	LDR R2, [R0, USART_ICR]
	ORR R2, 1 << UART_ORECF | 1 << UART_FECF @ clear the flags (by setting flags to 1)
	STR R2, [R0, USART_ICR]
	B read_loop


transmit_loop:

	BL wait_for_isr

	@ load the next value in the string into the transmit buffer for the specified UART
	LDRB R5, [R1], #1

	CMP R5, #0x24 @ check if the '$' symbol has been reached indicating to stop transmitting

	BEQ finish_transmit

	STRB R5, [R0, USART_TDR]

	B transmit_loop


wait_for_isr:
	LDR R3, [R0, USART_ISR] @ load the status of the UART
	ANDS R3, 1 << UART_TXE  @ 'AND' the current status with the bit mask that we are interested in
						    @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	@ loop back to check status again if the flag indicates there is no byte waiting
	BEQ wait_for_isr

	BX LR


finish_transmit:

	@ transmit carriage return and newline, then start reading again
	BL wait_for_isr

	MOV R5, #0x0D
	STRB R5, [R0, USART_TDR]

	BL wait_for_isr

	MOV R5, #0x0A
	STRB R5, [R0, USART_TDR]

	B part_d_main
