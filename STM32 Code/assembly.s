.syntax unified
.thumb

.global main

#include "definitions.s"
#include "initialise.s"
#include "exercise2a.s"
#include "exercise2bc.s"
#include "exercise2d.s"

.data
@ Define variables for Question 2.d
//ascii_string: .asciz "Put something here\0" @ Define a null-terminated string


.text

@ this is the entry function called from the startup file
main:

	@ Branch with link to set the clocks for the I/O and UART
	BL enable_peripheral_clocks

	@ Once the clocks are started, need to initialise the discovery board I/O
	BL initialise_discovery_board

@Exercise 2a, turn LEDs on with bitmask pattern
@ store the current light pattern (binary mask) in R4
	LDR R4, =0b10101010
	BL main_2a

@Exercise 2b and 2c, turns LEDs on/off with input button
	LDR R3, =0b00000000
	LDR R6, =#0 @led position checker
	BL wait_for_button

@Exercise 2d
	ascii_string: .asciz "Put your name here !\0" @ Define a null-terminated string
	BL main_2d

finished_everything:

	B finished_everything 	@ infinite loop here
