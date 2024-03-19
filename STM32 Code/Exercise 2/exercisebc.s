.syntax unified
.thumb

#include "definitions.s"

main_2bc:

	@Wait for the user input button to be pressed to go to the next command
	LDR R0, =GPIOA @load the address of the GPIOE register into R0
	LDRB R1, [R0, #IDR] @store this to the second byte of the ODR (bits 8-15) into R1
	ANDS R1, #0x01 @check if the button is pressed
	BNE button_pressed @branch to the next command once the button is pressed
	B delay_function @loop if button is not pressed

button_pressed:
	@check if all the leds are on
	LDR R3, =#0b10000000 @bitmask of only the last led is on
	CMP R2, R3 @if R2 > R3 --> a led should be turned on, else a led should be turned off
	BEQ reset @function that turns off the last led
	BMI turn_on @

 	@when R2 < R3, turn off a led
	LSLS R2, R2, #1 @shifts the bitmask to the left
	SUB R2, #128 @get rid of the overflow 9th binary bit
	SUB R2, #128
	LDR R0, =GPIOE @store the new bitmask into the GPIOE
	STRB R2, [R0, #ODR + 1]
	B delay_function

reset:
	LDR R2, =#0b00000000 @turn last led off
	LDR R0, =GPIOE @store the new bitmask into the GPIOE
	STRB R2, [R0, #ODR + 1]
	B delay_function


turn_on:
	LSLS R2, R2, #1 @shift to the left by 1
	ORR R2, R2, #1 @change the lowest bit to 1
	LDR R0, =GPIOE @store the new bitmask into the GPIOE
	STRB R2, [R0, #ODR + 1]
	B delay_function

delay_function: @delay the led and button pressing
	LDR R4, =#0x7A120
	BL delay_loop

delay_loop:
	SUBS R4, #1
	BGT delay_loop
	B main_2bc
