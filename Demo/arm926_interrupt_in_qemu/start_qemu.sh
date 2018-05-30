#!/bin/bash
set -x

qemu-system-arm -M versatilepb -serial stdio -kernel test.bin -nodefaults -nographic
