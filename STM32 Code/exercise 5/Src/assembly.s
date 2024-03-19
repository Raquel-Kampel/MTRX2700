.syntax unified
.thumb

.global main

#include "definitions.s"
#include "initialise.s"
#include "sub_cipher.s"
#include "letter_count.s"
#include "read.s"
#include "transmit.s"


.data

.text


main:

	@ functions for set up
	@ BL enable_timer2_clock
	BL enable_peripheral_clocks
	BL initialise_discovery_board
	BL initialise_power
	BL enable_uart

	B initialise_registers


initialise_registers:

	LDR R1, =incoming_buffer	@ buffer for storing string read in
	LDR R7, =buffer_size		@ size of buffer
	LDRB R7, [R7]				@ de-reference R7
	MOV R8, #0x00				@ counter for how many letters received

	@ uncomment for reading or transmitting:
	B transmitting

	@ B reading



transmitting:

	LDR R0, =USART1 	@ load USART1

	BL rx_loop			@ read from terminal, store message in R1

	MOV R2, #0  		@ set R2 to 0 (encoding mode)
	BL sub_cipher		@ encode message

	LDR R0, =UART4		@ load UART4

	BL return_after_tx	@ transmit to the other board

	B finish_everything


reading:

	LDR R0, =UART4		@ load UART4

	BL rx_loop			@ read from other board

	MOV R2, #1			@ set R2 to 1 (decoding mode)
	BL sub_cipher		@ decode message

	BL letter_count		@ display number of letters on LED

	B finish_everything


finish_everything:

	B finish_everything
