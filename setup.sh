#!/usr/bin/env bash
set -exuo pipefail
export DEBIAN_FRONTEND=noninteractive

QEMU_VER="1:8.2.2+ds-0ubuntu1.7"
GLIB_VER="2.80.0-6ubuntu3.4"
PKGCONF_VER="1.8.1-2build1"

cat <<'EOF' | sudo tee /etc/apt/sources.list.d/debsrc.list
deb-src http://archive.ubuntu.com/ubuntu noble          main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu noble-updates  main restricted universe multiverse
deb-src http://security.ubuntu.com/ubuntu noble-security main restricted universe multiverse
EOF

apt-get update
apt-get install -y --no-install-recommends \
        build-essential \
        git \
        python3 \
        python3-pip \
        gcc-arm-none-eabi \
        libnewlib-arm-none-eabi \
        libstdc++-arm-none-eabi-newlib \
        gdb-multiarch \
        scons \
        qemu-system-arm=${QEMU_VER} \
        libglib2.0-dev=${GLIB_VER} \
        pkg-config=${PKGCONF_VER} \
        dpkg-dev \
        meson \
        ninja-build \
        ca-certificates

mkdir -p /opt/qemu-dev && cd /opt/qemu-dev
apt-get source qemu=${QEMU_VER}
ln -s qemu-8.2.2+ds/include include
export QEMU_INC_DIR=/opt/qemu-dev/include  

apt-get clean && rm -rf /var/lib/apt/lists/*
