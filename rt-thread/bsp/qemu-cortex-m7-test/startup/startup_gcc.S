.section .vectors, "a"
    .word _estack
    .word Reset_Handler
    .word 0
    .word HardFault_Handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word SysTick_Handler
    .org 0x40

.text
.global Reset_Handler
Reset_Handler:
    ldr r0, =_estack
    mov sp, r0
    bl entry
1:  b 1b

