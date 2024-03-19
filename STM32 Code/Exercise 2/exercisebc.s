.syntax unified
.thumb

#include "definitions.s"

main_2bc:

	@Wait for the user input button to be pressed to go to the next command
	LDR R0, =GPIOA @load the address of the GPIOE register into R0
	LDRB R1, [R0, #IDR] @store this to the second byte of the ODR (bits 8-15) into R1
	ANDS R1, #0x01 @check if the button is pressed
	BNE button_pressed @branch to the next command
	B delay_function @loop if button is not pressed

button_pressed:
	@check if all the leds are on
	LDR R3, =#0b10000000
	CMP R2, R3
	BEQ reset
	BMI turn_on
	@turn off
	LSLS R2, R2, #1
	SUB R2, #128
	SUB R2, #128
	LDR R0, =GPIOE
	STRB R2, [R0, #ODR + 1]
	B delay_function

reset:
	LDR R2, =#0b00000000
	LDR R0, =GPIOE
	STRB R2, [R0, #ODR + 1]
	B delay_function


turn_on:
	LSLS R2, R2, #1
	ORR R2, R2, #1
	LDR R0, =GPIOE
	STRB R2, [R0, #ODR + 1]
	B delay_function

delay_function:
	LDR R4, =#0x7A120
	BL delay_loop

delay_loop:
	SUBS R4, #1
	BGT delay_loop
	B main_2bc
