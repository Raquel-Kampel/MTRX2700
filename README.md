# MTRX2700 Project 2

## Group Members
Raquel Kampel,
Eric Jiang,
Campbell Kerr

## Roles and Responbilities
- Question 1a - Together
          b - Raquel
          c - Campbell
- Question 2 - Eric
- Question 3 - Campbell
- Question 4 - Raquel
- Question 5 - Together

## Project Overview
All individual questions are coded in their own .s file. A main file is created to branch to each question when uncommented. 

## Exercise 1 # - Looping through characters in a ASCII string to perform different operations such as converting letters to lower/upper case, shifting the value of the string or encoding the messsge. 

### Summary
1.3.2a Converts the case of letters in a ASCII string based on the value stores in R2. The function traverses through the string until reaching the Null terminating character

1.3.2b Shifts down/up the alphabet based on user input, n the direction of a --> z or z --> a. Depending on if the hexidecimal value of the current letter is below "a" (0x61) or above "z" (0x7A), a right/left shift is applied until the null terminating character is reached which is the end of the string.

1.3.2c. The function uses a substitution table and a value indicating decoding or encoding

### Valid input
A valid ASCII string stored in memory with a null-terminating character. 
The state value stored in R2. For 1c, the value stored in register R4 determines the number of times the encoding or decoding process should be applied.

### Functions and modularity
There is a function to detemine which shift direction fucntion will be implemented. 
The left and right shift functions, each apply their own specific value to the string. There are also two seperate functions to determine if the current character is below a. 

### Testing
For part a: Providing test cases covering strings with various lengths and containing different combinations of uppercase and lowercase letters. Checking edge cases such as an empty string or a string with only one character.
Part b: Using putty to test. 
input a random string and adding a value to R2. 

### Notes
1a: 
- Conversion is based on the difference between lowercase and uppercase characters ('a' - 'A' = 32)
-  the function updates the string buffer with the new character and moves to the next character until the end of the string is reached.
  1b : Applys a shift in both positive and negative directions. 
  1 c: number of iterations determines how many times the encoding or decoding process should be applied. Decoding reverses the encoding process.
   
## Exercise 2 # - Digital I/O

## Summary
Exercise 2a Turns on the LEDs using a given bitmask

Exercise 2b Turns on LEDs one by one, using the user input button. One LED turns on after button is pressed once

Exercise 2c Turns off LEDs one by one, using the user input button. One LED turns off after button is pressed once

Exercise 2d Turns on number of LEDs based on the number of the same letter appears in a given string

## Explaination

2b & 2c Sets an initial bitmask of 0b00000000 for all LEDs are off, shift the bitmask to left by one every time when the user input button is pressed. The code compares the bitmask to 0b10000000, to check where if the very left bit of the bitmask is "1", this means a LED should be turned off, else a LED should be turned on. To turn on, the lowest bit of the bitmask will be changed to "1" after shifting to left by 1, and to turn off, the lowest bit of the bitmask will stay "0" after shifting to left by 1.

2d Using the letters a - z in ASCII, the code reads through each letter in the given string. When it needs to shift left, the code compares the current letter to "a" as it is the lowest ASCII lower case alphabet letter, if the new shifted letter is lower than "a", then adds 26 to the new letter so that it goes back from "z". When it needs to shift right, the code compares the current letter to "z" as it is the highest ASCII lower case alphabet letter, if the new shifted letter is higher than "a", then subtracts 26 to the new letter so that it starts from "a". 

  # Exercise 3 # - Serial Communication

### Summary
This exercise focuses on mastering UART (Universal Asynchronous Receiver/Transmitter) communication with the STM32 discovery board. By exploring asynchronous serial communication, participants will learn to transmit and receive strings of characters without shared clock information between devices, utilizing multiple UARTs on the board.
#### steps:
1. Setting up the USART1/ USART4
2. String Transmission Function
3. Button-Press Transmission Initiation
4. String Reception and Storage
5. Clock Speed and Baud Rate Configuration
### Usage
Implement a function to transmit strings using UART4. This function should take a pointer to the string as an argument and append a terminating character to the end of the transmission.

### Valid input
Any ASCII string
### Functions and modularity
Testing the transmitting vs receiving in two sperate steps as our device was bale to send but not receive
### Testing
using putty to test

### Notes
Polling vs. Interrupts: This exercise employs polling for UART communication. Future exercises will introduce interrupt-based techniques for more efficient communication handling.
## Exercise 4 # - Hardware Timer Delay Function with String Shifting

### Summary
The code creates delay periods using the Timer 2 (TIM2) that is configured in initialise.s file. The code implements a delay function using hardware timers and provides string shifting functionality.
#### steps:
 - start counter (timer control register 1) = TIM2_CR1 / Set a 1 in bit 0
 - TIM2_CNT
 - TIM2_PSC
 - TIM2_ARR is to shorten the counting period /auto-reload register


### Usage

### Valid input
The delay function takes a delay of any reasonable time passed through register R1.
### Functions and modularity

### Testing
 - Using putty to test
 - The delay function: Testing with various delay periods to verify accuracy, checking edge cases such as very short or very long delays.

### Notes
- using general purpose time TIM2 which is a 32-bit timer
- base adress of timer 2 = 0x4000 0000

- Selecting appropriate prescalar values
- count rate is is 8MHz:
  Tick duration 1/frequency x (Prescalar value + 1)
  
  eg, precalar of 1 = 8Mhz
  
  1 microsecond:
  prescalar value = [8MHz x (1x10^-6)/(1x10^-6)]-1 = 7

  1 second
  prescalar value = [8MHz x 1]/(1)-1 = 7999999

  1 hour
  prescalar = (8MHz x3600)-1 = 28799999

 - The Auto-Reload Preload (ARPE) bit is enabled for precise management of delay    
   periods entirely in hardware.
 - The delay function waits for the timer to reach the specified delay time before 
   returning.



   FOR 10 seconds:

   1/8Mhz = 1.25e-7 seconds to count 1 bit
   random prescalar of 100 = 100 times longer to cpount once = 1.25e-6
   for 10 seconds = 10/1.25e-6 = 8000000 which is value of auto reload register

   FOR 1 SECOND
   TIM_ARR = 800
   prescalar of 10000

   1 HOUR
   prescalar of 100000
    = 288000
  # Exercise 5 # - Integration Exercise

### Summary
This exercise serves as an integration task, combining the skills and functions developed in the first four exercises into a single comprehensive application. The objective is to utilize and integrate previously developed functions to accomplish a complex task involving serial communication and data processing between a PC, a STM32discovery board, and a second STM32discovery board using USART and UART protocols. The key operation involves encoding a message received from the PC with a Substitution Cipher and transmitting this encoded message to the second board for decoding and analysis.
#### steps:
1. Setup communication
2. send message from pc
3. encode message
4. transmit encoded message
5. decode and analyze the message
6. display the count 

### Usage
Ensure both STM32discovery boards are correctly wired for UART communication.
Load the necessary software onto both boards and the PC for UART communication and message encoding/decoding.

### Valid input
ASCII strings sent from the PC to the first STM32discovery board via USART1.
The inputs must be encodable and decodable by the Substitution Cipher used.
### Functions and modularity
1. UART Communication
2. Substitution Cipher Encoding and Decoding
3. Character Analysis and Display: 
### Testing
Unit Testing: Each function (UART communication, encoding/decoding, character analysis and display) was individually tested to ensure reliability and correct output.
Integration Testing: After unit testing, the functions were integrated step by step to ensure compatibility and correct flow of data through the system. This included testing the entire process from message sending from the PC to message reception and display on the second board.


### Notes
One of the main challenges was ensuring reliable UART communication between the different components, especially concerning synchronization and error handling. Another challenge was optimizing the cipher algorithm for efficient encoding and decoding on the STM32discovery boards
