# Test commands.
#
# make
# ./start_qemu.sh
# Test: input character, the console will response character+1
# Exit: Ctrl+c
# make clean

CROSS_PREFIX=/home/ryanyao/work/qemu/arm-2012.03/bin/arm-none-eabi-

all:
	$(CROSS_PREFIX)gcc -mcpu=arm926ej-s -c -o test.o test.c
	$(CROSS_PREFIX)gcc -mcpu=arm926ej-s -c -o vectors.o vectors.S
	$(CROSS_PREFIX)gcc -T test.ld test.o vectors.o -o test
	$(CROSS_PREFIX)objcopy -O binary test test.bin

clean:
	rm -rf test.bin test vectors.o test.o
