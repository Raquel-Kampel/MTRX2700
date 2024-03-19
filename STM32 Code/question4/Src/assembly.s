.syntax unified
.thumb

#include "initialise.s"

.global main
.global delay_function


.data
@ define variables
on_time: .word 0x10000
period: .word 0x80000


.text
@ define code

main:

	BL enable_timer2_clock
	BL enable_peripheral_clocks
	BL initialise_discovery_board

	@ load the base address for the timer into R0
	LDR R0, =TIM2


	@ Set the timer auto-reload register (TIM_ARR) for the desired delay
    LDR R3,= #0x1F40
    STR R3, [R0, TIM_ARR]

	@ start the timer running

	MOV R1, #0b1 @ store a 1 in bit zero for the CEN (counter enable) flag to enable the counter
	STR R1, [R0, TIM_CR1] @ enable the timer

	BL delay_function @ call the delay function

	B finished

delay_function:

		@start the timer by enabling the counter
	LDR R3, [R0, TIM_CR1]
	ORR R3,R3, #1 @ set the CEN bit to enablr the counter
	STR R3,[R0,TIM_CR1]

		@ store a value for the prescaler
	LDR R1,= #0x2710 @ put a prescaler in R1
	STR R1, [R0, TIM_PSC] @ set the prescaler register


	MOV R2, R1 @load the delay from R1

	//LDR R3, =0 @reset the counter
	//STR R3, [R0, TIM_CNT]

	@reset the timer
	@set bit zero in erg to 1
	LDR R0, = TIM2
	LDR R1, [R0, TIM_EGR]
	ORR R1, 1 << TIM2EGR
	STR R1, [R0, TIM_EGR]


	@ Reset the UIF bit in the TIM_SR register
    LDR R3, [R0, TIM_SR]
    LDR R2 ,=0xFFFE
    AND R2, R3
    STR R2, [R0, TIM_SR]


	/*
	@for last question
	@ Enable the Auto-Reload Preload (ARPE) bit
    LDR R3, [R0, TIM_CR1]
    ORR R3, R3, #(1 << 7)  @ Set the ARPE bit (bit 7)
    STR R3, [R0, TIM_CR1]
	*/


	@wait for timer to reach specific delay time

	B delay_loop

delay_loop:
	LDR R3, [R0, TIM_SR] @loads the value of the timer status register into R3
	AND R3, #1 @ and R3 and 1
    TEQ R3, #1 @ Check the UIF (Update Interrupt Flag) bit
    BEQ delay_done @ Wait until the timer overflows (UIF is set)
    B delay_loop

delay_done:
	LDR R4, =0b00000001
	LDR R0, =GPIOE  @ load the address of the GPIOE register into R0
	STRB R4, [R0, #ODR + 1]   @ store this to the second byte of the ODR (bits 8-15)

    @ Stop the timer
    LDR R3, [R0, TIM_CR1]
    BIC R3, R3, #1 @ Clear the CEN bit to disable the counter
    STR R3, [R0, TIM_CR1]


    BX LR @ Return from the delay function

finished:
	 B finished


