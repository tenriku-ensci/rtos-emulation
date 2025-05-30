.syntax unified
.cpu cortex-m7
.thumb

.extern rtthread_startup

.section .vectors, "a", %progbits
.type g_pfnVectors, %object
.global g_pfnVectors

g_pfnVectors:
    .word _estack
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

.size g_pfnVectors, . - g_pfnVectors

.section .text.Reset_Handler
.thumb
.global Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    ldr r0, =_sidata
    ldr r1, =__data_start
    ldr r2, =__data_end
1:
    cmp r1, r2
    ittt lt
    ldrlt r3, [r0], #4
    strlt r3, [r1], #4
    blt 1b

    ldr r0, =__bss_start__
    ldr r1, =__bss_end__
    movs r2, #0
2:
    cmp r0, r1
    itt lt
    strlt r2, [r0], #4
    blt 2b

    /* Enable FPU */
    ldr r0, =0xE000ED88
    ldr r1, [r0]
    orr r1, r1, #(0xF << 20)
    str r1, [r0]

    bl rtthread_startup
    b .
.size Reset_Handler, . - Reset_Handler

.weak NMI_Handler
.thumb_set NMI_Handler, Default_Handler
.weak HardFault_Handler
.thumb_set HardFault_Handler, Default_Handler
.weak MemManage_Handler
.thumb_set MemManage_Handler, Default_Handler
.weak BusFault_Handler
.thumb_set BusFault_Handler, Default_Handler
.weak UsageFault_Handler
.thumb_set UsageFault_Handler, Default_Handler
.weak SVC_Handler
.thumb_set SVC_Handler, Default_Handler
.weak DebugMon_Handler
.thumb_set DebugMon_Handler, Default_Handler
.weak PendSV_Handler
.thumb_set PendSV_Handler, Default_Handler
.weak SysTick_Handler
.thumb_set SysTick_Handler, Default_Handler

.global Default_Handler
.type Default_Handler, %function
Default_Handler:
    b .
.size Default_Handler, . - Default_Handler

