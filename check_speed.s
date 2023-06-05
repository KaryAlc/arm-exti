.section .text
.align	1
.syntax unified
.thumb
.global check_speed

# check_speed:
# El código proporcionado es una función que se encarga de ajustar 
# la velocidad de un sistema en función de un valor pasado como argumento.

check_speed:
    mov     r0, r8          @ speed = r8
    cmp     r8, #1          @ ¿speed == 1?
    bne     L2              @ Branch to L2
    mov     r3, #1000       @ r3 = 1000
    b       L3              @Branch to L3
L2:
    cmp     r8, #2          @ ¿speed == 2?
    bne     L4              @ Branch to L4
    mov     r3, #500        @ r3 = 500
    b       L3              @Branch to L3
L4:
    cmp     r8, #3          @ ¿speed == 3?
    bne     L5              @ Branch to L5
    movs    r3, #250        @ r3 = 250
    b       L3              @ Branch to L3
L5:
    cmp     r8, #4          @ ¿speed == 4?
    bne     L6              @ Branch to L6
    movs    r3, #125        @ r3 = 125
    b       L3              @ Branch to L3
L6:
    movs    r8, #1          @ ¿speed == 1?
    mov     r3, #1000       @ r3 = 1000
L3:
    mov     r0, r3          @ r0 = 1000
    bx      lr

.size   check_speed, .-check_speed


