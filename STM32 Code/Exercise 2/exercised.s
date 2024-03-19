.syntax unified
.thumb


#include "definitions.s"

main_2d:

	LDR R2, =#0  	@use r2 to count the number of leds that needs to be turned on (number of the same letter)
	LDR R3, =#0 	@counter to the current place in the string
	LDR R4, =#0	@check if all 26 letters in the alphabet have been checked
	LDR R5, =#0x61   @current letter in the alphabet that are being counted


wait_for_button_2d:

	LDR R6, =#0b00000000 @set led bitmask
	LDR R0, =GPIOA
	LDRB R1, [R0, #IDR]
	ANDS R1, #0x01
	BNE letter_count @branch to function that counts the letter once the button is pressed
	B delay_function

letter_count:
	LDR R0, =ascii_string  @load the string into r0
	CMP R4, #27 @check if all 26 letters have been checked
	BEQ finished_everything @end if all letters have been checked

	LDRB R1, [R0, R3]	@load current letter in the string into R1
	CMP R1, #0 @check if the end of the string
	BEQ end_of_string

	CMP R5, R1 @check if it is the same letter
	BEQ add_led @if same --> one led needs to be added
	ADD R3, #1 @next letter (position in the string) 
	B letter_count @loops to check the next letter of the string

end_of_string:
	ADD R4, #1 @store the next letter in the alphabet that needs to be checked into R4
	LDR R3, =0 @reset current letter checker
	BL set_bitmask @set bitmask to turn leds on or off


add_led:
	ADD R2, #1 @number of letters (leds) +1
	ADD R3, #1 @next letter (position in the string)
	B letter_count @loops to check the next letter of the string

set_bitmask:
	CMP R2, #0 @no more leds need to be added
	BEQ turn_led @turn leds on using bitmask

	LSLS R6, R6, #1 @shift bitmask to the left by 1
	ORR R6, R6, #1 @make the lowest bit of the bitmask 1

	SUB R2, #1 @one less led needs to be added into bitmask
	B set_bitmask @loop until no more leds need to be added

turn_led:
	LDR R0, =GPIOE @turn leds on using bitmask
	STRB R6, [R0, #ODR + 1]
	ADD R5, #1 @set the next letter in the alphabet that needs to be counted
	B delay_function_d

delay_function_2d:
	LDR R4, =#0x7A120
	BL delay_loop_2d

delay_loop_2d:
	SUBS R4, #1
	BGT delay_loop_2d
	B wait_for_button_2d

finished_everything:

	B finished_everything 	@ infinite loop here
