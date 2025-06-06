@ base register for resetting and clock settings
.equ RCC, 0x40021000
.equ AHBENR, 0x14	@ register for enabling clocks
.equ APB1ENR, 0x1C
.equ APB2ENR, 0x18
.equ AFRH, 0x24		@ alternate function register (high)
.equ AFRL, 0x20		@ alternate function register (low)
.equ RCC_CR, 0x00 	@ control clock register
.equ RCC_CFGR, 0x04 @ configure clock register

@ timer 2 enable
.equ TIM2EN, 0


@ UART registers
.equ USART1, 0x40013800
.equ UART4, 0x40004C00

@ UART enable bits
.equ USART1_EN, 14
.equ UART4_EN, 19

@ register addresses and offsets for general UARTs
.equ USART_CR1, 0x00
.equ USART_BRR, 0x0C
.equ USART_ISR, 0x1C @ UART status register offset
.equ USART_ICR, 0x20 @ UART clear flags for errors

.equ UART_TE, 3		@ transmit enable bit
.equ UART_RE, 2		@ receive enable bit
.equ UART_UE, 0		@ enable bit for the whole UART
.equ UART_ORE, 3	@ Overrun flag
.equ UART_FE, 1		@ Frame error

.equ UART_ORECF, 3	@ Overrun clear flag
.equ UART_FECF, 1	@ Frame error clear flag


@ GPIO definitions
.equ GPIOA, 0x48000000	@ base register for GPIOA (pa0 is the button)
.equ GPIOB, 0x48000400	@ base register for GPIOA (pa0 is the button)
.equ GPIOC, 0x48000800	@ base register for GPIOA (pa0 is the button)
.equ GPIOD, 0x48000C00	@ base register for GPIOD (pe8-15 are the LEDs)
.equ GPIOE, 0x48001000	@ base register for GPIOE (pe8-15 are the LEDs)

.equ GPIOA_ENABLE, 17	@ enable bit for GPIOA
.equ GPIOB_ENABLE, 18	@ enable bit for GPIOB
.equ GPIOC_ENABLE, 19	@ enable bit for GPIOC
.equ GPIOD_ENABLE, 20	@ enable bit for GPIOD
.equ GPIOE_ENABLE, 21	@ enable bit for GPIOE

.equ IDR, 0x10			@ GPIO input register
.equ ODR, 0x14			@ GPIO output register

.equ GPIO_MODER, 0x00	@ set the mode for the GPIO
.equ GPIO_OSPEEDR, 0x08	@ set the speed for the GPIO


@ transmitting and receiving data
.equ UART_TXE, 7		@ a new byte is ready to read
.equ USART_TDR, 0x28	@ a new byte is ready to read

.equ UART_RXNE, 5		@ a new byte is ready to read
.equ USART_RDR, 0x24	@ a new byte is ready to read
.equ USART_RQR, 0x18
.equ UART_RXFRQ, 3		@ a new byte is ready to read


@ setting the clock speed higher using the PLL clock option
.equ HSEBYP, 18			@ bypass the external clock
.equ HSEON, 16 			@ set to use the external clock
.equ HSERDY, 17 		@ wait for this to indicate HSE is ready
.equ PLLON, 24 			@ set the PLL clock source
.equ PLLRDY, 25 		@ wait for this to indicate PLL is ready
.equ PLLEN, 16 			@ enable the PLL clock
.equ PLLSRC, 16
.equ USBPRE, 22 		@ with PLL active, this must be set for the USB

.equ PWREN, 28
.equ SYSCFGEN, 0


@ timer defined values
.equ TIM2, 0x40000000	@ base address for TIM2
.equ TIM_CR1, 0x00		@ control registers
.equ TIM_CCMR1, 0x18  	@ compare capture settings register
.equ TIM_CNT, 0x24  	@ The actual counter location
.equ TIM_ARR, 0x2C  	@ The register for the auto-reload
.equ TIM_PSC, 0x28  	@ prescaler
.equ TIM_CCER, 0x20 	@ control register for output/capture
.equ TIM_CCR1, 0x34 	@ capture/compare register for channel 1
.equ TIM_SR, 0x10 		@ status of the timer
.equ TIM_DIER, 0x0C 	@ enable interrupts
