.syntax unified
.thumb

#include "definitions.s"

	//Question 2.b & c
wait_for_button:

@	Wait for button:
	LDR R0, =GPIOA
	LDRB R1, [R0, #IDR]
	ANDS R1, #0x01
	BNE button_pressed
	B wait_for_button

button_pressed:
	LDR R0, =GPIOE
	@check if all the leds are on
	LDR R5, =#0b10000000
	CMP R3, R5
	BEQ reset
	BMI turn_on
	@turn off
	LSLS R3, R3, #0
	ORR R3, R3, #0
	STRB R3, [R0, #ODR + 1]
	ADD R6, #1
	B wait_for_button

reset:
	LSLS R3, R3, #0
	ORR R3, R3, #0
	STRB R3, [R0, #ODR + 1]
	LDR R6, =0
	B wait_for_button


turn_on:
	LSLS R3, R3, #1
	ORR R3, R3, #1
	STRB R3, [R0, #ODR + 1]
	ADD R6, #1
	B wait_for_button
