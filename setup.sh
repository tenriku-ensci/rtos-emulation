#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
        build-essential \
        git \
        python3 \
        python3-pip \
        gcc-arm-none-eabi \
        gdb-multiarch \
        scons

apt-get clean && rm -rf /var/lib/apt/lists/*

