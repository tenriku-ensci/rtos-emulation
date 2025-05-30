import os

ARCH = 'arm'
CPU = 'cortex-m7'
CROSS_TOOL = 'gcc'
PLATFORM = 'gcc'
EXEC_PATH = os.getenv('RTT_EXEC_PATH') or '/usr/bin'
BUILD = 'debug'
LINK_SCRIPT = 'link.lds'

if PLATFORM == 'gcc':
    PREFIX = os.getenv('RTT_CC_PREFIX') or 'arm-none-eabi-'
    CC = PREFIX + 'gcc'
    CXX = PREFIX + 'g++'
    AS = PREFIX + 'gcc'
    AR = PREFIX + 'ar'
    LINK = PREFIX + 'gcc'
    TARGET_EXT = 'elf'
    SIZE = PREFIX + 'size'
    OBJDUMP = PREFIX + 'objdump'
    OBJCPY = PREFIX + 'objcopy'
    STRIP = PREFIX + 'strip'
    DEVICE = ' -mcpu=cortex-m7 -mthumb '
    CFLAGS = DEVICE + '-Wall -Wno-cpp -std=gnu99 -ffunction-sections -fdata-sections'
    AFLAGS = ' -c' + DEVICE + ' -x assembler-with-cpp'
    LFLAGS = DEVICE + ' -Wl,--gc-sections,-Map=rtthread.map -T ' + LINK_SCRIPT
    if BUILD == 'debug':
        CFLAGS += ' -O0 -g'
        AFLAGS += ' -g'
    else:
        CFLAGS += ' -Os'

    POST_ACTION = OBJCPY + ' -O binary $TARGET rtthread.bin\n' + SIZE + ' $TARGET\n'
