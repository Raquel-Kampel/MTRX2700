.syntax unified
.thumb

#include "definitions.s"

.data

tx_string: .asciz "this is a message\r"

.text


part_a_main:

	LDR R0, =USART1	@ load UART
	MOV R2, #0		@ flag for if button was pressed on the previous check

	B wait_for_button


wait_for_button:

	@ load the button input data and check if it is 1
	LDR R3, =GPIOA
	LDR R4, [R3, IDR]
	AND R4, 1 @ get the first bit in the IDR (button signal)
	CMP R4, 1
	BEQ button_pressed

	MOV R2, #0

	B wait_for_button


button_pressed:

	@ check if button was pressed on the previous check
	CMP R2, 1
	BEQ wait_for_button

	LDR R1, =tx_string	@ string to transmit
	MOV R2, #1

	@ start transmitting, and wait for button again when finished
	BL return_after_tx
	B wait_for_button


return_after_tx:

	@ store where to return to so it doesn't get overwritten
	MOV R6, LR

	B tx_loop


tx_loop:

	@ wait until ready to transmit
	BL wait_for_ISR

	@ load the current byte
	LDRB R5, [R1], #1
	STRB R5, [R0, USART_TDR]

	@ check for carriage return (enter key), indicating to stop transmitting
	CMP R5, #0x0D
	BNE tx_loop

	B finish_transmit


wait_for_ISR:

	LDR R3, [R0, USART_ISR]
	ANDS R3, 1 << UART_TXE
	BEQ wait_for_ISR

	BX LR


finish_transmit:

	BL wait_for_ISR

	@ transmit a newline character
	MOV R5, #0x0A
	STRB R5, [R0, USART_TDR]

	BX R6
