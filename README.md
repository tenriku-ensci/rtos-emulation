# RT-Thread Emulation

This project aims to emulate RT-Thread on QEMU. The RT-Thread source code is referenced as a Git submodule at tag `v5.0.0`.

## Fetching Submodules

After cloning this repository, run the following command to fetch the RT-Thread source:

```bash
git submodule update --init --recursive
```


## Building RT-Thread

After fetching the submodule, build the RT-Thread QEMU target using the provided
development container:

```bash
# build the container
docker build -t rtos-dev -f .devcontainer/Dockerfile .

# update submodules (if not already fetched)
git submodule update --init --recursive

# build the QEMU BSP
cd rt-thread/bsp/qemu-vexpress-a9
scons -j$(nproc)
```

The resulting firmware image will be located in the `rt-thread/bsp/qemu-vexpress-a9` directory.
