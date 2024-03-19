.syntax unified
.thumb


#include "definitions.s"

.data

.text


letter_count:

	MOV R2, #0  	@ number of leds to be turned on
	MOV R3, #0 		@ counter to the current place in the string
	MOV R4, #0		@ check if all 26 letters in the alphabet have been checked
	LDR R5, =0x61  	@current letter that are being counted


count_loop:

	CMP R4, #27 @ check if all 26 letters have been checked
	BEQ stop_count

	LDRB R0, [R1, R3]	@ load current letter into R0
	CMP R0, #0x0D 		@ check if the end of the string
	BEQ end_of_string

	CMP R5, R0 @ check if it is the same letter
	BEQ add_led @ one led needs to be added
	ADD R3, #1
	B count_loop


end_of_string:

	ADD R4, #1 	@ store the next letter in the alphabet that needs to be checked into R4
	MOV R3, #0 	@ reset current letter checker
	LDR R6, =0b00000000 @ set led bitmask
	B set_bitmask


add_led:

	ADD R2, #1
	ADD R3, #1
	B count_loop


set_bitmask:

	CMP R2, #0
	BEQ turn_led

	LSLS R6, R6, #1
	ORR R6, R6, #1

	SUB R2, #1
	B set_bitmask


turn_led:

	LDR R0, =GPIOE
	STRB R6, [R0, #ODR + 1]
	ADD R5, #1
	B delay_function


delay_function:

	LDR R2, =0x7A120
	B delay_loop

delay_loop:

	SUBS R2, #1
	BGT delay_loop
	B count_loop


stop_count:

	BX LR 	@ return
