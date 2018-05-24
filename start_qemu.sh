#!/bin/bash

qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -kernel test64.elf
