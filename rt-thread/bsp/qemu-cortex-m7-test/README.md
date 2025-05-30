# QEMU Cortex-M7 Test BSP

This board support package targets the `mps2-an500` machine in QEMU which emulates a Cortex-M7 CPU. The configuration is minimal and only enables a single UART for console output.

## Building

```bash
cd rt-thread/bsp/qemu-cortex-m7-test
scons -j$(nproc)
```

The resulting `rtthread.bin` image can then be executed with QEMU.

## Running

```bash
cd rt-thread/bsp/qemu-cortex-m7-test
./qemu-nographic.sh
```

After the system boots you should see the RT-Thread shell on the terminal.
