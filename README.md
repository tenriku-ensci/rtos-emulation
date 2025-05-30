# RT-Thread Emulation

This project aims to emulate RT-Thread on QEMU. The repository contains a trimmed copy of RT-Thread version `v5.0.0`. Only the QEMU BSPs remain and the `drivers/usb` and `documents` directories were removed.

## Building RT-Thread

Build the RT-Thread QEMU target using the provided development container:

```bash
# build the container
docker build -t rtos-dev -f .devcontainer/Dockerfile .

# build the QEMU BSP
cd rt-thread/bsp/qemu-vexpress-a9
scons -j$(nproc)
```

The resulting firmware image will be located in the `rt-thread/bsp/qemu-vexpress-a9` directory.

## Running on QEMU

After building the firmware you can launch it with:

```bash
cd rt-thread/bsp/qemu-vexpress-a9
bash qemu-nographic.sh
```

The script starts `qemu-system-arm` in headless mode and boots the `rtthread.bin` image. Once the boot process finishes you should see the RT-Thread shell prompt in the terminal. If no output appears, ensure `BSP_USING_UART0` is enabled in `.config` and rebuild.

## Minimal Cortex-M7 BSP

A lightweight BSP using QEMU's `mps2-an500` machine is also available under the
`qemu-cortex-m7-test` directory. Build it with:

```bash
cd rt-thread/bsp/qemu-cortex-m7-test
scons -j$(nproc)
```

Run the image with:

```bash
cd rt-thread/bsp/qemu-cortex-m7-test
./qemu-nographic.sh
```

The board will boot and print the RT-Thread banner on the serial console.
