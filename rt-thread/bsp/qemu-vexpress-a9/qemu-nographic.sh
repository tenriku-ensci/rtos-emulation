if [ ! -f "sd.bin" ]; then
dd if=/dev/zero of=sd.bin bs=1024 count=65536
fi

qemu-system-arm -M vexpress-a9 -smp cpus=2 -kernel rtthread.bin -nographic \
    -drive if=sd,format=raw,file=sd.bin \
    -serial mon:stdio -audio none

