.syntax unified
.thumb


#include "definitions.s"

.data
ascii_string: .asciz "aaabbcddddeeeee\0" @ Define a null-terminated string

main_2d:

	LDR R0, =ascii_string  @the address of the string
	LDR R2, =#0  	@number of leds to be turned on
	LDR R3, =#0 		@counter to the current place in the string
	LDR R4, =#0		@check if all 26 letters in the alphabet have been checked
	LDR R5, =#0x61   @current alphabet that are being counted
	LDR R6, =#0b00000000 @led bitmask

wait_for_button_d:
@	Wait for button:
	LDR R0, =GPIOA
	LDRB R1, [R0, #IDR]
	ANDS R1, #0x01
	BNE letter_count
	B wait_for_button_d

letter_count:
	CMP R4, #27 @check if all 26 letters have been checked
	BEQ finished_everything

	LDRB R1, [R0, R3]	@ load current letter into R1
	CMP R1, #0 @ check if the end of the string
	BEQ end_of_string

	CMP R5, R1 @check if it is the same letter
	BEQ add_led @one led needs to be added
	ADD R3, #1
	B letter_count

end_of_string:
	ADD R4, #1 @store the next letter in the alphabet that needs to be checked into R4
	LDR R3, =0 @reset current letter checker
	BL set_bitmask


add_led:
	ADD R2, #1
	ADD R3, #1
	B letter_count

set_bitmask:
	CMP R2, #0
	BEQ turn_led

	LSLS R6, R6, #1
	ORR R6, R6, #1

	SUB R2, #1
	B set_bitmask

turn_led:
	STRB R6, [R0, #ODR + 1]
	ADD R5, #1
	B wait_for_button_d
