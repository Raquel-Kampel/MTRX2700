.syntax unified
.thumb

.global main

#include "definitions.s"
#include "initialise.s"
#include "exercise2a.s"
#include "exercise2bc.s"
#include "exercise2d.s"

.data

@ Define variables for Question 2.d, bitmask that is needed to count the number of a letter
ascii_string: .asciz "aaabbddddflllooxxxxxyyzzzzzzz\0"


.text

main:

	@ Branch with link to set the clocks for the I/O and UART
	BL enable_peripheral_clocks

	@ Once the clocks are started, need to initialise the discovery board I/O
	BL initialise_discovery_board

@Exercise 2a, turn LEDs on with bitmask pattern

/*
	LDR R1, =0b10101010 @store the current light pattern (binary mask) in R1
	BL main_2a @branch to the function for exercise 2a
*/

@Exercise 2b and 2c, turns LEDs on/off with the user input button

/*
	LDR R2, =#0b00000000 @stores the original bitmask of the leds into r2
	BL main_2bc @branch to the function for exercise 2b and 2c
*/

@Exercise 2d

/*
 	BL main_2d @branch to the function for exercise 2d
*/

