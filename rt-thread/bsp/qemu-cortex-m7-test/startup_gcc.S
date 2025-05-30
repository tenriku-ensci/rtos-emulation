/* Minimal Cortex-M7 startup for QEMU MPS2-AN500 */
    .syntax unified
    .cpu cortex-m7
    .thumb

    .section .vectors,"a",%progbits
    .globl g_pfnVectors
    .type g_pfnVectors, %object
    .align 2
    .globl Reset_Handler
    .globl Default_Handler
g_pfnVectors:
    .word   _estack
    .word   Reset_Handler
    .word   Default_Handler /* NMI */
    .word   Default_Handler /* HardFault */
    .word   Default_Handler /* MemManage */
    .word   Default_Handler /* BusFault */
    .word   Default_Handler /* UsageFault */
    .word   0
    .word   0
    .word   0
    .word   0
    .word   Default_Handler /* SVCall */
    .word   Default_Handler /* Debug monitor */
    .word   0
    .word   Default_Handler /* PendSV */
    .word   SysTick_Handler

    /* simple vector table for remaining IRQs */
    .rept 240-16
        .word Default_Handler
    .endr
    .size g_pfnVectors, . - g_pfnVectors

    .text

Reset_Handler:
    ldr   r0, =_estack
    mov   sp, r0

    /* enable FPU full access */
    ldr   r0, =0xE000ED88
    ldr   r1, [r0]
    orr   r1, r1, #(0xF << 20)
    str   r1, [r0]

    /* relocate data */
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata
1:
    cmp r1, r2
    ittt lt
    ldrlt r3, [r0], #4
    strlt r3, [r1], #4
    blt 1b

    /* clear bss */
    ldr r0, =__bss_start
    ldr r1, =__bss_end
    mov r2, #0
2:
    cmp r0, r1
    it lt
    strlt r2, [r0], #4
    blt 2b

    bl SystemInit
    bl rtthread_startup

Default_Handler:
    b Default_Handler

    .end
