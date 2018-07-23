# Test commands.
#	make run
#	Ctrl-A X (Exit)


IMAGE := kernel.elf

# GCC flags
CFLAG = -c
OFLAG = -o
INCLUDEFLAG = -I
CROSS = aarch64-linux-gnu
CC = ${CROSS}-gcc
AS = ${CROSS}-as
LD = ${CROSS}-ld
OBJDUMP = ${CROSS}-objdump
CFLAGS =  -mcpu=cortex-a57 -Wall -Wextra -g
#	-mcpu=name
#		Specify the name of the target processor
#	-Wall
#		Turns on all optional warnings which are desirable for normal code
#	-Wextra
#		This enables some extra warning flags that are not enabled by -Wall
#	-g  Produce debugging information in the operating system's native format.
#		 GDB can work with this debugging information.

ASM_FLAGS = -mcpu=cortex-a57 -g

# Compiler/target path in FreeRTOS/Source/portable
PORT_COMP_TARG = GCC/ARM_CA57_64_BIT/

# Intermediate directory for all *.o and other files:
OBJDIR = obj/

# FreeRTOS source base directory
FREERTOS_SRC = ./FreeRTOS/Source/

# Directory with memory management source files
FREERTOS_MEMMANG_SRC = $(FREERTOS_SRC)portable/MemMang/

# Directory with platform specific source files
FREERTOS_PORT_SRC = $(FREERTOS_SRC)portable/$(PORT_COMP_TARG)

# Directory with HW drivers' source files
DRIVERS_SRC = drivers/

# Directory with Application source files
APP_SRC = ./FreeRTOS/Demo/CORTEX_A57_64-bit/

# Due to a large number, the .o files are arranged into logical groups:

FREERTOS_OBJS = queue.o list.o tasks.o
# The following o. files are only necessary if
# certain options are enabled in FreeRTOSConfig.h
#FREERTOS_OBJS += timers.o
#FREERTOS_OBJS += croutine.o
#FREERTOS_OBJS += event_groups.o
#FREERTOS_OBJS += stream_buffer.o

# Only one memory management .o file must be uncommented!
FREERTOS_MEMMANG_OBJS = heap_1.o
#FREERTOS_MEMMANG_OBJS = heap_2.o
#FREERTOS_MEMMANG_OBJS = heap_3.o
#FREERTOS_MEMMANG_OBJS = heap_4.o
#FREERTOS_MEMMANG_OBJS = heap_5.o


# FREERTOS_PORT_OBJS = port.o portISR.o
FREERTOS_PORT_OBJS = port.o portASM.o
DRIVERS_OBJS = uart.o

# APP_OBJS = init.o main.o print.o receive.o
# APP_OBJS = main.o FreeRTOS_asm_vectors.o
APP_OBJS = kernel.o boot.o
# nostdlib.o must be commented out if standard lib is going to be linked!
# APP_OBJS += nostdlib.o


# All object files specified above are prefixed the intermediate directory
# OBJS = $(addprefix $(OBJDIR), $(FREERTOS_OBJS) $(FREERTOS_MEMMANG_OBJS) $(TEST_OBJS) $(FREERTOS_PORT_OBJS) $(DRIVERS_OBJS) $(APP_OBJS))
OBJS = $(addprefix $(OBJDIR), $(DRIVERS_OBJS) $(APP_OBJS) )

ELF_IMAGE = image.elf

$(info $(APP_SRC))
# Include paths to be passed to $(CC) where necessary
INC_FREERTOS = $(FREERTOS_SRC)include/
INC_DRIVERS = $(DRIVERS_SRC)include/

# Complete include flags to be passed to $(CC) where necessary
# INC_FLAGS = $(INCLUDEFLAG)$(INC_FREERTOS) $(INCLUDEFLAG)$(APP_SRC) $(INCLUDEFLAG)$(FREERTOS_PORT_SRC)
# INC_FLAGS = $(INCLUDEFLAG)$(INC_FREERTOS) $(INCLUDEFLAG). $(INCLUDEFLAG)$(FREERTOS_PORT_SRC)
INC_FLAGS = $(INCLUDEFLAG)$(APP_SRC) $(INCLUDEFLAG)$(INC_DRIVERS)
INC_FLAG_DRIVERS = $(INCLUDEFLAG)$(INC_DRIVERS)


all: $(OBJDIR) $(IMAGE)

$(OBJDIR) :
	mkdir -p $@

all: $(IMAGE)

${IMAGE}: $(APP_SRC)linker.ld ${OBJS}
	${LD} -T $(APP_SRC)linker.ld $^ -o $@
	${OBJDUMP} -D kernel.elf > kernel.list

# Drivers

$(OBJDIR)uart.o : $(DRIVERS_SRC)uart.c
	# $(CC) $(CFLAG) $(CFLAGS) $(INC_FLAG_DRIVERS) $< $(OFLAG) $@
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAG_DRIVERS) $< $(OFLAG) $@

# Demo application

$(OBJDIR)boot.o : $(APP_SRC)boot.S
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)kernel.o: $(APP_SRC)kernel.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< -o $@

run:
	$(MAKE) kernel.elf
	# qemu-system-aarch64 -machine virt -cpu cortex-a57 -m 128 -serial stdio -nographic -nodefaults -kernel kernel.elf
	# qemu-system-aarch64 -machine virt,gic_version=3 -cpu cortex-a57 -nographic -kernel kernel.elf
	qemu-system-aarch64 -machine virt -cpu cortex-a57 -nographic -kernel kernel.elf

gen_tags:
	./gen_tags.sh

clean_tags:
	rm -rf tags cscope*

clean:
	rm -f *.o *.elf *.list
	rm -rf $(OBJDIR)

.PHONY: run gen_tags clean_tags clean
