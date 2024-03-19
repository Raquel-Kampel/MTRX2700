.syntax unified
.thumb

#include "definitions.s"

main_2bc:

	@Wait for the user input button to be pressed to go to the next command
	LDR R0, =GPIOA @load the address of the GPIOE register into R0
	LDRB R1, [R0, #IDR] @store this to the second byte of the ODR (bits 8-15) into R1
	ANDS R1, #0x01 @check if the button is pressed
	BNE button_pressed @branch to the next command
	B wait_for_button @loop if button is not pressed

button_pressed:
	@check if all the LEDs are on
	LDR R5, =#0b10000000 @
	CMP R3, R5
	BEQ reset
	BMI turn_on
	@turn off
	LSLS R3, R3, #1
	LDR R0, =GPIOE
	STRB R3, [R0, #ODR + 1]
	B wait_for_button

reset:
	LSLS R3, R3, #1
	LDR R0, =GPIOE
	STRB R3, [R0, #ODR + 1]
	B wait_for_button


turn_on:
	LSLS R3, R3, #1
	ORR R3, R3, #1
	LDR R0, =GPIOE
	STRB R3, [R0, #ODR + 1]
	B wait_for_button
