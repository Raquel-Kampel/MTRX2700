.syntax unified
.thumb

#include "definitions.s"

main_2a:
	LDR R0, =GPIOE  @load the address of the GPIOE register into R0
	STRB R4, [R0, #ODR + 1]   @store the bitmask to the second byte of the ODR (bits 8-15)

	B main_2a @return to the program_loop label
