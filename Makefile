# Cross-compiler for ARM
AS = as
LD = ld
OBJCOPY = objcopy

# Compiler and linker flags
LDFLAGS = -T stm32f103c8t6.ld

# List of source files
SRCS = main.s ivt.s SysTick_Handler.s reset_handler.s Default_Handler.s check_speed.s delay.s exti_handler.s output.s SysTick_Initialize.s
# List of object files
OBJS = $(SRCS:.s=.o)

# Main target
all: prog.bin

# Compile ARM assembly source files into object files
%.o: %.s
	$(AS) -o $@ $<

# Link object files into an ELF executable
prog.elf: $(OBJS) stm32f103c8t6.ld
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

# Convert ELF executable into a binary image
prog.bin: prog.elf
	$(OBJCOPY) -O binary $< $@

# Clean up object files and binary image
cleanwin:
	Del /F $(OBJS) prog.elf prog.bin

# Clean up object files and binary image
clean:
	rm -f $(OBJS) prog.elf prog.bin	

.PHONY: all clean
