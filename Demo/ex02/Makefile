# export PATH=$PATH:/home/ryanyao/work/buildroot-2017.11-rc1/output/host/bin

# Test commands.
#
# make
# ./start_qemu (Exit: Ctrl+a x)
# make clean

TOOLCHAIN = aarch64-linux-gnu-
CC = $(TOOLCHAIN)gcc
CXX = $(TOOLCHAIN)g++
AS = $(TOOLCHAIN)as
LD = $(TOOLCHAIN)ld
OBJCOPY = $(TOOLCHAIN)objcopy
AR = $(TOOLCHAIN)ar

# GCC flags
CFLAG = -c
OFLAG = -o
INCLUDEFLAG = -I
CPUFLAG = -mcpu=cortex-a57
WFLAG = -Wall -Wextra -Werror
WFLAG = 
CFLAGS = $(CPUFLAG) $(WFLAG)

# Additional C compiler flags to produce debugging symbols
DEB_FLAG = -g -DDEBUG


# Compiler/target path in FreeRTOS/Source/portable
PORT_COMP_TARG = GCC/ARM_CA53_64_BIT/

# Intermediate directory for all *.o and other files:
OBJDIR = obj/

# FreeRTOS source base directory
FREERTOS_SRC = ../../FreeRTOS/Source/

# Directory with memory management source files
FREERTOS_MEMMANG_SRC = $(FREERTOS_SRC)portable/MemMang/

# Directory with platform specific source files
FREERTOS_PORT_SRC = $(FREERTOS_SRC)portable/$(PORT_COMP_TARG)


# Due to a large number, the .o files are arranged into logical groups:

TEST_OBJS = test64.o startup64.o

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
# APP_OBJS = init.o main.o print.o receive.o
APP_OBJS = main.o FreeRTOS_asm_vectors.o 
# nostdlib.o must be commented out if standard lib is going to be linked!
APP_OBJS += nostdlib.o


# All object files specified above are prefixed the intermediate directory
# OBJS = $(addprefix $(OBJDIR), $(STARTUP_OBJ) $(FREERTOS_OBJS) $(FREERTOS_MEMMANG_OBJS))
# OBJS = $(addprefix $(OBJDIR), $(FREERTOS_OBJS) )
OBJS = $(addprefix $(OBJDIR), $(FREERTOS_OBJS) $(FREERTOS_MEMMANG_OBJS) $(TEST_OBJS) $(FREERTOS_PORT_OBJS) $(APP_OBJS))

ELF_IMAGE = image.elf

# Include paths to be passed to $(CC) where necessary
INC_FREERTOS = $(FREERTOS_SRC)include/
# INC_DRIVERS = $(DRIVERS_SRC)include/

# Complete include flags to be passed to $(CC) where necessary
# INC_FLAGS = $(INCLUDEFLAG)$(INC_FREERTOS) $(INCLUDEFLAG)$(APP_SRC) $(INCLUDEFLAG)$(FREERTOS_PORT_SRC)
INC_FLAGS = $(INCLUDEFLAG)$(INC_FREERTOS) $(INCLUDEFLAG). $(INCLUDEFLAG)$(FREERTOS_PORT_SRC)
# INC_FLAG_DRIVERS = $(INCLUDEFLAG)$(INC_DRIVERS)

# all: $(OBJDIR) test64.elf $(ELF_IMAGE) 
# all: $(OBJDIR) test64.elf 
all: $(OBJDIR) $(ELF_IMAGE) 

$(OBJDIR) :
	mkdir -p $@

$(ELF_IMAGE): $(OBJS)
	$(LD) -nostdlib -T test64.ld $^ $(OFLAG) $@

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


# HW specific part, in FreeRTOS/Source/portable/$(PORT_COMP_TARGET)

$(OBJDIR)port.o : $(FREERTOS_PORT_SRC)port.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)portASM.o : $(FREERTOS_PORT_SRC)portASM.S
	$(AS) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@


test64.elf: $(OBJDIR)test64.o $(OBJDIR)startup64.o
	$(LD) -Ttest64.ld $^ $(OFLAG) $@

$(OBJDIR)test64.o: test64.c
	$(CC) $(CFLAG) $(CFLAGS) $< $(OFLAG) $@

$(OBJDIR)startup64.o: startup64.s
	$(AS) $(CPUFLAG) $< $(OFLAG) $@

test64.bin: test64.elf
	$(OBJCOPY) -O binary $< $@

# Demo application

$(OBJDIR)main.o : $(APP_SRC)main.c
	$(CC) $(CFLAG) $(CFLAGS) $(INC_FLAGS) $< $(OFLAG) $@

$(OBJDIR)nostdlib.o : $(APP_SRC)nostdlib.c
	$(CC) $(CFLAG) $(CFLAGS) $< $(OFLAG) $@

$(OBJDIR)FreeRTOS_asm_vectors.o : $(APP_SRC)FreeRTOS_asm_vectors.S
	$(AS) $(CFLAG) $(CFLAGS) $< $(OFLAG) $@

# Cleanup directives:

clean:
	rm -f test64.bin test64.elf image.elf
	rm -rf $(OBJDIR)
