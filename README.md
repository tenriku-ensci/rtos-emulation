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
