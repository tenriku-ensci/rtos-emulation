#!/usr/bin/env bash
qemu-system-arm -M mps2-an500 -kernel rtthread.bin -nographic -serial mon:stdio
