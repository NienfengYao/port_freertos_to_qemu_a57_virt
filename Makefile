# Test commands.
#	make run
#	Ctrl-A X (Exit)

# GCC flags
CFLAG = -c
OFLAG = -o
INCLUDEFLAG = -I
CROSS = aarch64-linux-gnu
CC = ${CROSS}-gcc
AS = ${CROSS}-as
LD = ${CROSS}-ld
OBJDUMP = ${CROSS}-objdump
CFLAGS = -mcpu=cortex-a57 -Wall -Wextra -g -DGUEST
#	-mcpu=name
#		Specify the name of the target processor
#	-Wall
#		Turns on all optional warnings which are desirable for normal code
#	-Wextra
#		This enables some extra warning flags that are not enabled by -Wall
#	-g
#		Produce debugging information in the operating system's native format.
#		GDB can work with this debugging information.
#	-DGUEST
#		#define GUEST /* At the time of writing, we only supports EL1. */

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
# APP_OBJS = kernel.o start.o FreeRTOS_asm_vectors.o
APP_OBJS = main.o start.o FreeRTOS_asm_vectors.o FreeRTOS_tick_config.o
APP_OBJS += vectors.o exception.o sysctrl.o pstate.o gic_v3.o
# nostdlib.o must be commented out if standard lib is going to be linked!
APP_OBJS += nostdlib.o


# All object files specified above are prefixed the intermediate directory
# OBJS = $(addprefix $(OBJDIR), $(FREERTOS_OBJS) $(FREERTOS_MEMMANG_OBJS) $(TEST_OBJS) $(FREERTOS_PORT_OBJS) $(DRIVERS_OBJS) $(APP_OBJS))
OBJS = $(addprefix $(OBJDIR), $(FREERTOS_OBJS) $(FREERTOS_MEMMANG_OBJS) $(FREERTOS_PORT_OBJS) $(DRIVERS_OBJS) $(APP_OBJS) )

ELF_IMAGE = image.elf

$(info $(APP_SRC))
# Include paths to be passed to $(CC) where necessary
INC_FREERTOS = $(FREERTOS_SRC)include/
INC_DRIVERS = $(DRIVERS_SRC)include/
INC_APP = $(APP_SRC)include/

# Complete include flags to be passed to $(CC) where necessary
# INC_FLAGS = $(INCLUDEFLAG)$(INC_FREERTOS) $(INCLUDEFLAG)$(APP_SRC) $(INCLUDEFLAG)$(FREERTOS_PORT_SRC)
# INC_FLAGS = $(INCLUDEFLAG)$(INC_FREERTOS) $(INCLUDEFLAG). $(INCLUDEFLAG)$(FREERTOS_PORT_SRC)
INC_FLAGS = $(INCLUDEFLAG)$(INC_FREERTOS) $(INCLUDEFLAG)$(INC_APP) $(INCLUDEFLAG)$(INC_DRIVERS) $(INCLUDEFLAG)$(FREERTOS_PORT_SRC)
INC_FLAG_DRIVERS = $(INCLUDEFLAG)$(INC_DRIVERS)


all: $(OBJDIR) $(ELF_IMAGE)

$(OBJDIR) :
	mkdir -p $@

${ELF_IMAGE}: $(APP_SRC)linker.ld ${OBJS}
	${LD} -T $(APP_SRC)linker.ld $^ -o $@
	${OBJDUMP} -D $(ELF_IMAGE) > image.list

# FreeRTOS core

$(OBJDIR)queue.o : $(FREERTOS_SRC)queue.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)list.o : $(FREERTOS_SRC)list.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)tasks.o : $(FREERTOS_SRC)tasks.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

# Rules for all MemMang implementations are provided
# Only one of these object files must be linked to the final target

$(OBJDIR)heap_1.o : $(FREERTOS_MEMMANG_SRC)heap_1.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)heap_2.o : $(FREERTOS_MEMMANG_SRC)heap_2.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)heap_3.o : $(FREERTOS_MEMMANG_SRC)heap_3.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)heap_4.o : $(FREERTOS_MEMMANG_SRC)heap_4.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)heap_5.o : $(FREERTOS_MEMMANG_SRC)heap_5.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

# Drivers

$(OBJDIR)uart.o : $(DRIVERS_SRC)uart.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAG_DRIVERS) $< $(OFLAG) $@

# HW specific part, in FreeRTOS/Source/portable/$(PORT_COMP_TARGET)

$(OBJDIR)port.o : $(FREERTOS_PORT_SRC)port.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)portASM.o : $(FREERTOS_PORT_SRC)portASM.S
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

# Demo application


$(OBJDIR)start.o : $(APP_SRC)start.S
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)nostdlib.o : $(APP_SRC)nostdlib.c
	$(CC) $(CFLAG) $(CFLAGS) $< $(OFLAG) $@

$(OBJDIR)FreeRTOS_asm_vectors.o : $(APP_SRC)FreeRTOS_asm_vectors.S
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)FreeRTOS_tick_config.o : $(APP_SRC)FreeRTOS_tick_config.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)vectors.o : $(APP_SRC)vectors.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)exception.o : $(APP_SRC)exception.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)sysctrl.o : $(APP_SRC)sysctrl.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)pstate.o : $(APP_SRC)pstate.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)gic_v3.o : $(APP_SRC)gic_v3.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)main.o: $(APP_SRC)main.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< -o $@

run:
	$(MAKE) all
	# qemu-system-aarch64 -machine virt -cpu cortex-a57 -m 128 -serial stdio -nographic -nodefaults -kernel kernel.elf
	qemu-system-aarch64 -machine virt -cpu cortex-a57 -nographic -kernel $(ELF_IMAGE)

gen_tags: clean_tags
	./gen_tags.sh

clean_tags:
	rm -rf tags cscope*

clean:
	rm -f *.o *.elf *.list
	rm -rf $(OBJDIR)

.PHONY: run gen_tags clean_tags clean
