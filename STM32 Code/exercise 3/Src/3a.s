.syntax unified
.thumb

#include "definitions.s"

.data

tx_string: .asciz "this is a message\r\n$"


.text


part_a_main:
	MOV R2, #0	@ flag for if button was pressed on the previous check


wait_for_button:

	LDR R3, =GPIOA		@ port for the input button
	LDR R4, [R3, IDR]	@ load input data register for port A
	AND R4, 1 			@ check if PA0 (button input) is 1 (pressed)
	CMP R4, 1
	BEQ tx_loop			@ if button is pressed, transmit message

	MOV R2, #0

	B wait_for_button


tx_loop:

	CMP R2, 1
	BEQ wait_for_button

	LDR R0, =UART
	LDR R1, =tx_string

	MOV R2, #1


tx_uart:

	LDR R3, [R0, USART_ISR] @ load the status of the UART
	ANDS R3, 1 << UART_TXE  @ 'AND' the current status with the bit mask that we are interested in
						    @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	@ loop back to check status again if the flag indicates there is no byte waiting
	BEQ tx_uart

	@ load the next value in the string into the transmit buffer for the specified UART
	LDRB R5, [R1], #1

	CMP R5, #0x24 @ check if the '$' symbol has been reached indicating to stop transmitting

	BEQ wait_for_button

	STRB R5, [R0, USART_TDR]

	B tx_uart
