.section .text
.global _start

@ Register and memory address definitions
.equ RCC_BASE, 0x40021000   @ RCC base address
.equ GPIOA_BASE, 0x48000000 @ GPIOA base address

.equ RCC_AHBENR, 0x14       @ RCC AHBENR register offset
.equ GPIOA_MODER, 0x00      @ GPIOA MODER register offset
.equ GPIOA_ODR, 0x14        @ GPIOA ODR register offset
.equ GPIOB_MODER, 0x04      @ GPIOB MODER register offset
.equ GPIOB_IDR, 0x10        @ GPIOB IDR register offset

@ LED pin definitions
.equ LED_PIN_0, 4           @ Pin number for LEDs
.equ LED_PIN_1, 5
.equ LED_PIN_2, 6
.equ LED_PIN_3, 7
.equ LED_PIN_4, 8
.equ LED_PIN_5, 9
.equ LED_PIN_6, 10
.equ LED_PIN_7, 11

.equ LED_MASK, (1 << LED_PIN_0) | (1 << LED_PIN_1) | (1 << LED_PIN_2) | (1 << LED_PIN_3) | \
                (1 << LED_PIN_4) | (1 << LED_PIN_5) | (1 << LED_PIN_6) | (1 << LED_PIN_7)

.equ Button_Pressed, 0      @ Button pressed state

@ Delay count definition
.equ DELAY_COUNT, 1000000   @ Number of iterations for delay loop

.data
led_state: .word 0           // Variable that stores the LED state

set_up:
    @ Enable clock for GPIOA and GPIOB
    LDR R0, =RCC_BASE
    LDR R1, =RCC_AHBENR
    LDR R2, =0x000A0004        @ Loads the clock enable mask for GPIOA and GPIOB into R2
    STR R2, [R0, R1]           @ Stores the clock enable mask into RCC_AHBENR register

    @ Setup GPIOA for output (LEDs)
    LDR R0, =GPIOA_BASE
    LDR R1, =GPIOA_MODER
    LDR R2, =0x55555555        @ Loads bitmask to set all pins as output into r2
    STR R2, [R0, R1]           @ Stores bitmask into GPIOA_MODER register

    @ Setup GPIOB for input (button)
    LDR R0, =GPIOB_BASE
    LDR R1, =GPIOB_MODER
    LDR R2, =0xFFFFFFFC        @ Loads bitmask to set all pins as input except pin 0 into r2
    STR R2, [R0, R1]           @ Stores bitmask into GPIOB_MODER register

main_loop:
    @ Read the user input, button state
    LDR R0, =GPIOB_BASE
    LDR R1, =GPIOB_IDR
    LDRB R2, [R0, R1]          @ Loads user input button state into R2
    TST R2, #1                 @ Test if user input button is pressed
    BEQ .no_input     		   @ Branch if button is not pressed

    @ If the button is pressed, the next LED state is changed
    BL turn_led
    B .main_loop

.no_input:
    B .main_loop

turn_led:
    @ Read current LED state
    LDR R0, =led_state
    LDR R3, [r0]               @ Loads the current LED state

    @ Increment LED state in order to make a cycle
    ADD R3, R3, #1             @ Increment LED state by 1
    CMP R3, #8                 @ Compare LED state with 8 as there are only 8 LEDs
    MOV R3, #0                @ Reset LED state to 0 if all LEDs are turned on
    STR R3, [R0]               @ Store updated LED state

    @ Turn on or off the current LED
    LDR R0, =GPIOA_BASE
    LDR R1, =GPIOA_ODR
    LDR R2, [R0, R1]
    LSL R2, R2, R3             @ Shift 1 left by the LED index
    TST R2, #1                 @ Check if the LED  is on
    BNE .turn_off 			   @ If LED is on, then turn it off

	@if LED is off, then turn it on
    MOV R2, #1
    LSL R2, R2, R3             // Shift 1 left by the LED index
    ORR R2, R2, R3             @ Set bit corresponding to the LED index
    STR R2, [R0, R1]           @ Store bitmask into GPIOA_ODR register to turn the LED ON or OFF

    @ Delay so the LEDs stay on or off
    LDR R4, =DELAY_COUNT       @ Load delay count into r4
    BL delay
    BX LR

.turn_off:
    LDR R0, =GPIOA_BASE        // Load GPIOA_BASE address into r0
    LDR R1, =GPIOA_ODR         // Load GPIOA_ODR offset into r1
    MOV R2, #1                 // Load 1 into r2
    LSL R2, R2, R3             // Shift 1 left by the LED index
    MVN R2, R2                 // Negate the value in r2 (bitwise NOT)
    AND R2, R2, R3             // Clear the bit corresponding to the LED index
    STR R2, [R0, R1]           // Store bitmask into GPIOA_ODR register
	@ Delay so the LEDs stay on or off
    LDR R4, =DELAY_COUNT       @ Load delay count into r4
    BL delay
    BX LR

delay:
    // Insert delay loop here
    // Example delay loop (adjust as needed)
    mov r5, #0                 // Load 0 into r5

loop_delay:
    ADD r5, r5, #1
    CMP r5, r4                 @ Compares r5 with r4
    BNE loop_delay             @ Branch back to loop_delay if they are not equal
    BX LR
