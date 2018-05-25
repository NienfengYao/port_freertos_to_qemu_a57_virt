#!/bin/bash
set -x

qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -kernel image.elf
