.syntax unified
.thumb

main_2d:

	LDR R0, =ascii_string  @ the address of the string
	LDR R2, =0  	@count the amount of the same letter
	LDR R3, =0 		@counter to the current place in the string
	LDR R4, =0		@counter of alphabet
	LDR R5, =0x61   @alphapet checker
	LDR R6, =0b00000000 @led bitmask

wait_for_button:
@	Wait for button:
	LDR R0, =GPIOA
	LDRB R1, [R0, #IDR]
	ANDS R1, #0x01
	BNE letter_count
	B wait_for_button

letter_count:
	CMP R4, #27 @check if all letters have been checked
	BEQ finish_everything

	LDRB R1, [R0, R3]	@ load current letter into R1
	CMP R1, #0 @ check if the end of the string
	BEQ end_of_String

	CMP R5, R1 @check if it is the same letter
	BEQ add_led @number of leds needs to be added
	B wait_for_button

end_of_string:
	ADD R4, #1
	LDR R3, =0
	BL set_bitmask
	B wait_for_button

add_led:
	ADD R2, #1
	ADD R3, #1
	B wait_for_button

set_bitmask:
	CMP R2, #0
	BEQ turn_led
	ORR R6, 1 << R2
	SUB R2, #1

turn_led:
	LRDB R1, =[R4] @turn led on
	STRB R1, [R0, #ODR + 1]
	ADD R5, #1
	B wait_for_button
