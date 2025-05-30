.syntax unified
.cpu cortex-m7
.thumb

.global Reset_Handler
.global __StackTop

.section .vectors, "a"
__StackTop = 0x20080000

Vectors:
    .word __StackTop
    .word Reset_Handler
    .word NMI_Handler
    .word HardFault_Handler
    .word MemManage_Handler
    .word BusFault_Handler
    .word UsageFault_Handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word SVC_Handler
    .word DebugMon_Handler
    .word 0
    .word PendSV_Handler
    .word SysTick_Handler

    .size Vectors, .-Vectors

    .section .text.Reset_Handler
    .weak NMI_Handler
    .weak HardFault_Handler
    .weak MemManage_Handler
    .weak BusFault_Handler
    .weak UsageFault_Handler
    .weak SVC_Handler
    .weak DebugMon_Handler
    .weak PendSV_Handler

NMI_Handler:
    b .
HardFault_Handler:
    b .
MemManage_Handler:
    b .
BusFault_Handler:
    b .
UsageFault_Handler:
    b .
SVC_Handler:
    b .
DebugMon_Handler:
    b .
PendSV_Handler:
    b .

Reset_Handler:
    /* Clear .bss */
    ldr r0, =__bss_start
    ldr r1, =__bss_end
    movs r2, #0
1:
    cmp r0, r1
    it lt
    strlt r2, [r0], #4
    blt 1b

    bl entry
    b .
