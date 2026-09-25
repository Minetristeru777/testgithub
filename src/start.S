.syntax unified
.cpu cortex-a7
.arm

.section .text.boot, "ax", %progbits
.global _start
.type _start, %function
.extern main
.extern __bss_start
.extern __bss_end
.extern __stack_top

_start:
    ldr sp, =__stack_top

    ldr r0, =__bss_start
    ldr r1, =__bss_end
    mov r2, #0

clear_bss:
    cmp r0, r1
    strlo r2, [r0], #4
    blo clear_bss

    bl main

hang:
    wfi
    b hang

.size _start, . - _start
