OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(Reset_Handler)

MEMORY
{
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 4M
    RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 4M
}

SECTIONS
{
    . = ORIGIN(ROM);
    .vectors : { KEEP(*(.vectors)) } > ROM

    .text :
    {
        *(.text*)
        *(.init)
        *(.fini)
    } > ROM

    .rodata : { *(.rodata*) } > ROM

    . = ALIGN(4);
    _sidata = .;
    .data : AT(_sidata)
    {
        __data_start = .;
        *(.data*)
        __data_end = .;
    } > RAM

    .bss (NOLOAD) :
    {
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        __bss_end__ = .;
    } > RAM

    PROVIDE(_estack = ORIGIN(RAM) + LENGTH(RAM));
}
