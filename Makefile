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
PORT_COMP_TARG = GCC/ARM_CA53_64_BIT

# Intermediate directory for all *.o and other files:
OBJDIR = obj/
# OBJDIR = 

# FreeRTOS source base directory
FREERTOS_SRC = FreeRTOS/Source/


# Object files to be linked into an application
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

# All object files specified above are prefixed the intermediate directory
# OBJS = $(addprefix $(OBJDIR), $(STARTUP_OBJ) $(FREERTOS_OBJS) $(FREERTOS_MEMMANG_OBJS))
OBJS = $(addprefix $(OBJDIR), test64.o startup64.o)

ELF_IMAGE = test64.elf

all: $(OBJDIR) $(ELF_IMAGE)

$(OBJDIR) :
	mkdir -p $@

$(OBJDIR)test64.o: test64.c
	$(CC) $(CFLAG) $(CFLAGS) $< $(OFLAG) $@

$(OBJDIR)startup64.o: startup64.s
	$(AS) $(CPUFLAG) $< $(OFLAG) $@

$(ELF_IMAGE): $(OBJS)
	$(LD) -nostdlib -T test64.ld $^ $(OFLAG) $@

test64.bin: test64.elf
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f test64.bin test64.elf
	rm -r $(OBJDIR)
