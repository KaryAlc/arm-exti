.section .text
.align	1
.syntax unified
.thumb
.global delay

# delay:
# Esta función implementa un bucle que se ejecuta hasta que el valor 
# del registro r10 (pasado como argumento) sea igual a cero. Esto crea 
# un retardo en la ejecución del programa, ya que el bucle se repite 
# hasta que se cumple la condición.

delay:
        mov     r10, r0                 @ r10 = counter
loop:
        cmp     r10, #0                 @ ¿r10 == 0?
        bne     loop                    @ Branch to loop
        bx      lr                      

.size   delay, .-delay


