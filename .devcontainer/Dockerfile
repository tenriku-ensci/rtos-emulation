FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        python3 \
        python3-pip \
        gcc-arm-none-eabi \
        gdb-multiarch \
        scons \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]
