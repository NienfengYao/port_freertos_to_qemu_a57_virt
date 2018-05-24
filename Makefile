# Test commands.
#
# make
# ./start_qemu (Exit: Ctrl+a x)
# make clean


CROSS_PREFIX=/home/ryanyao/work/buildroot-2017.11-rc1/output/host/bin/aarch64-linux-gnu-

all: test64.elf

test64.o: test64.c
	$(CROSS_PREFIX)gcc -c $< -o $@

startup64.o: startup64.s
	$(CROSS_PREFIX)as -c $< -o $@

test64.elf: test64.o startup64.o
	$(CROSS_PREFIX)ld -Ttest64.ld $^ -o $@

test64.bin: test64.elf
	$(CROSS_PREFIX)objcopy -O binary $< $@

clean:
	rm -f test65.bin test64.elf startup64.o test64.o
