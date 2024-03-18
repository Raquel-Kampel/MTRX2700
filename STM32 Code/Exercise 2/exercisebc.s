.syntax unified
.thumb

#include "definitions.s"

	//Question 2.b & c
	LDR R3, =#0b00000000

wait_for_button:

@	Wait for button:
	LDR R0, =GPIOA
	LDRB R1, [R0, #IDR]
	ANDS R1, #0x01
	BNE button_pressed
	B wait_for_button

button_pressed:
	@check if all the leds are on
	LDR R5, =#0b10000000
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
