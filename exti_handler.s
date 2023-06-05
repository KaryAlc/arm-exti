
.include "exti_map.inc"
.section .text
.align	1
.syntax unified
.thumb
.global exti_handler

# exti_handler:
# Función de controlador de interrupción externa (EXTI) 

exti_handler:
        ldr     r0, =EXTI_BASE                  @ Dirección base
        ldr     r0, [r0, EXTI_PR_OFFSET]        @ Registro de prioridad
        ldr     r1, =0x00000400                 @ Enable bit of EXTI 10
        cmp     r0, r1                          @ compare 
        beq     exti_handler10
        ldr     r1, =0x00000800                 @  Enable bit of EXTI 11
        cmp     r0, r1 
        beq     exti_handler11
        bx      lr

exti_handler10:
        adds    r8, r8, #1                      @ r8 = r8 + 1
        ldr     r0, =EXTI_BASE                  @ Dirección base
        ldr     r2, [r0, EXTI_PR_OFFSET] 
        orr     r2, r2, 0x400
        str     r2, [r0, EXTI_PR_OFFSET]  
        bx      lr       

exti_handler11:
        eor     r9, r9, 1
        and     r9, r9, 0x1
        ldr     r0, =EXTI_BASE
        ldr     r2, [r0, EXTI_PR_OFFSET] 
        orr     r2, r2, 0x800
        str     r2, [r0, EXTI_PR_OFFSET] 
        bx      lr

.size   exti_handler, .-exti_handler


