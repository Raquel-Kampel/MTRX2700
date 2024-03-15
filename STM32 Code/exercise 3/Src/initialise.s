.syntax unified
.thumb

#include "definitions.s"



@ enable peripheral clocks for A-E
enable_peripheral_clocks:

	@ load the address of the RCC address boundary (for enabling the IO clock)
	LDR R0, =RCC

	@ enable all of the GPIO peripherals in AHBENR
	LDR R1, [R0, #AHBENR]
	ORR R1, 1 << GPIOE_ENABLE | 1 << GPIOD_ENABLE | 1 << GPIOC_ENABLE | 1 << GPIOB_ENABLE | 1 << GPIOA_ENABLE
	STR R1, [R0, #AHBENR]

	BX LR



enable_uart:
	@ enable USART1 and UART4
	@ UART1 uses pc4 and pc5, UART4 uses pc10 and pc11

	LDR R0, =GPIOC

	@ set AF7 for pc4 & pc5
	LDR R1, =0x77
	STRB R1, [R0, AFRL + 2]

	@ set AF5 for pc10 & pc11
	LDR R1, =0x55
	STRB R1, [R0, AFRH + 1]

	@ modify pins 4,5,10,11 for alternate function mode
	LDR R1, [R0, GPIO_MODER]
	LDR R2, =0xA00A00
	ORR R1, R2 @ Mask for pins to change to 'alternate function mode'
	STR R1, [R0, GPIO_MODER]

	@ set high speed for pins 4,5,10,11
	LDR R1, [R0, GPIO_OSPEEDR]
	LDR R2, =0xF00F00
	ORR R1, R2 @ mask for pins to be set as high speed
	STR R1, [R0, GPIO_OSPEEDR]

	@ set USART1 enable bit
	LDR R0, =RCC 			@ the base address for the register to turn clocks on/off
	LDR R1, [R0, #APB2ENR]	@ load the original value from the enable register
	ORR R1, 1 << USART1_EN	@ apply the bit mask to the previous values of the enable the UART
	STR R1, [R0, #APB2ENR]	@ store the modified enable register values back to RCC

	@ set UART4 enable bit
	LDR R1, [R0, #APB1ENR]
	ORR R1, 1 << UART4_EN
	STR R1, [R0, #APB1ENR]

	@ set the baud rate (115200)
	MOV R1, #0x46				@ calculated value using the base speed of 8MHz
	LDR R0, =USART1 			@ USART1 base address
	STRH R1, [R0, #USART_BRR]
	LDR R0, =UART4				@ UART4 base address
	STRH R1, [R0, #USART_BRR]

	@ enable USART1 transmitting and receiving
	LDR R0, =USART1
	LDR R1, [R0, #USART_CR1]
	ORR R1, 1 << UART_TE | 1 << UART_RE | 1 << UART_UE
	STR R1, [R0, #USART_CR1]

	@ enable UART4 transmitting and receiving
	LDR R0, =UART4
	LDR R1, [R0, #USART_CR1]
	ORR R1, 1 << UART_TE | 1 << UART_RE | 1 << UART_UE
	STR R1, [R0, #USART_CR1]

	BX LR @ return



change_clock_speed:
	@ switch to HSE (high speed external clock) so PLL can be used (multiplies frequency)

	LDR R0, =RCC
	LDR R1, [R0, #RCC_CR]
	LDR R2, =1 << HSEBYP | 1 << HSEON @ bits that enable HSE
	ORR R1, R2
	STR R1, [R0, #RCC_CR]

	@ wait until HSE is ready
wait_for_HSERDY:
	LDR R1, [R0, #RCC_CR]	@ load clock control register
	TST R1, 1 << HSERDY		@ check if HSE is ready
	BEQ wait_for_HSERDY

	@ can now switch to PLL

	LDR R1, [R0, #RCC_CFGR] 					@ load clock configure register
	LDR R2, =1 << 20 | 1 << PLLSRC | 1 << 22	@ the last term is for the USB prescaler to be 1
	ORR R1, R2  								@ multiplies speed by 6
	STR R1, [R0, #RCC_CFGR] 					@ store the modified enable register values back to RCC

	@ enable PLL
	LDR R0, =RCC
	LDR R1, [R0, #RCC_CR]	@ load the original value from the enable register
	ORR R1, 1 << PLLON		@ apply the bit mask to turn on the PLL
	STR R1, [R0, #RCC_CR]	@ store the modified enable register values back to RCC

@ wait for PLL to be ready
wait_for_PLLRDY:
	LDR R1, [R0, #RCC_CR]	@ load the original value from the enable register
	TST R1, 1 << PLLRDY		@ test the HSERDY bit (check if it is 1)
	BEQ wait_for_PLLRDY

@ switch system clock to PLL
	LDR R0, =RCC
	LDR R1, [R0, #RCC_CFGR]		@ load the current value of the peripheral clock registers
	MOV R2, 1 << 10 | 1 << 1	@ bit 1 (SW = 10)  - PLL set as system clock
								@ bit 10 (HCLK=100) divide APB1 by 2
	ORR R1, R2
	STR R1, [R0, #RCC_CFGR] 	@ store the modified register back to the submodule

	LDR R1, [R0, #RCC_CFGR]		@ load the current value of the peripheral clock registers
	ORR R1, 1 << USBPRE			@ set the USB prescaler (when PLL is on for the USB)
	STR R1, [R0, #RCC_CFGR]		@ store the modified register back to the submodule

	BX LR @ return



@ initialise the power systems on the microcontroller
@ PWREN (enable power to the clock), SYSCFGEN system clock enable
initialise_power:

	LDR R0, =RCC @ the base address for the register to turn clocks on/off

	@ enable clock power in APB1ENR
	LDR R1, [R0, #APB1ENR]
	ORR R1, 1 << PWREN @ apply the bit mask for power enable
	STR R1, [R0, #APB1ENR]

	@ enable clock config in APB2ENR
	LDR R1, [R0, #APB2ENR]
	ORR R1, 1 << SYSCFGEN @ apply the bit mask to allow clock configuration
	STR R1, [R0, #APB2ENR]

	BX LR @ return
