.syntax unified
.thumb

#include "definitions.s"

.data

.text


return_after_tx:

	@ store where to return to so it doesn't get overwritten
	MOV R6, LR

	B tx_loop


tx_loop:

	@ wait until ready to transmit
	BL wait_for_ISR

	@ load the current byte
	LDRB R3, [R1], #1
	STRB R3, [R0, USART_TDR]

	@ check for carriage return (enter key), indicating to stop transmitting
	CMP R3, #0x0D
	BEQ finish_transmit

	B tx_loop


wait_for_ISR:

	LDR R3, [R0, USART_ISR]
	ANDS R3, 1 << UART_TXE
	BEQ wait_for_ISR

	BX LR


finish_transmit:

	BL wait_for_ISR

	@ transmit a newline character
	MOV R3, #0x0A
	STRB R3, [R0, USART_TDR]

	BX R6
