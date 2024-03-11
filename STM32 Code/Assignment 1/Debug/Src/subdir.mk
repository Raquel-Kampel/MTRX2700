################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (11.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/1,2,3a.s \
../Src/1,2,3b.s \
../Src/1,2,3c.s \
../Src/assembly.s 

OBJS += \
./Src/1,2,3a.o \
./Src/1,2,3b.o \
./Src/1,2,3c.o \
./Src/assembly.o 

S_DEPS += \
./Src/1,2,3a.d \
./Src/1,2,3b.d \
./Src/1,2,3c.d \
./Src/assembly.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/1,2,3a.d ./Src/1,2,3a.o ./Src/1,2,3b.d ./Src/1,2,3b.o ./Src/1,2,3c.d ./Src/1,2,3c.o ./Src/assembly.d ./Src/assembly.o

.PHONY: clean-Src

