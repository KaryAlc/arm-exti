# LAB6 - Karina Alcantara Segura

## Funcionamiento del proyecto:

El código presentado fue basado en la plantilla arm-gpio-template y arm-blink, recuperado de: https://github.com/Ryuuba/arm-gpio-template y https://github.com/Ryuuba/arm-blink respectivamente.

De igual forma las funciones Systick_Initialize.s, Systic_Handler.s fueron tomadas del libro "Embedded Systems wit ARM Cortex-M Microcontrollers in Assembly Language in C - Third Edition" de Dr. Yifeng Zhu.

## main.s:

### - setup:

Como primer paso, se inicializan los puertos GPIO, este codigo esta configurado para funcionar con salidas del pin **`A0 a A9`**, y entradas en el pin **`A10 a A11`** (0011 para salidas y 1000 para entradas).

Luego, se configuran los EXTI, en este caso  **`EXTI 10 Y EXTI 11`**, se comienza inicializando el  **`AFIO_BASE`**, y limpiamos un registro que pasaremos posteriormente a **`AFIO_EXTICR3_OFFSET`** para selecionar a **`A10 y A11`** como entradas.

Para la inicializacion de los EXTI se carga primero el **`EXTI_BASE`**, despues la constante en donde se cargara el evento y por ultimo se desenmascara la solicitud de interrupcion. Para finalizar se activa **`NVIC_BASE`** para atender la solicitud de las interrupciones y se inicializa el systick.

### - loop:

Comenzamos con declarar en el registro 0 nuestro **`counter = 0`**, en el registro 8 nuestro **`speed = 1`** y en el registro 9 nuestro **`mode = 0`**.
Despues entra a la condicion de check_speed, que se encarga de la modificacion de velocidad, su funcionamiento esta descrito mas adelante.
Despues por medio de etiquetas y saltos se verifica el valor en el que se encuentra mode y dependiendo el caso aumenta o decrementa el contador, se realiza el delay y se manda al archivo de output.

 ### SysTick_Initialize

Esta funcion corresponde a la función de inicialización del temporizador de sistema (SysTick), en primer lugar se carga la dirección base del temporizador de sistema (SysTick) en el registro r0, luego establecen el registro de control del temporizador de sistema **` STK_CTRL_OFFSET`** en 0 para deshabilitar la interrupción del SysTick y el contador del temporizador de sistema, y seleccionar la fuente de reloj externa. Limpiamos el valor del systick y asignamos el valor del intervalo que se guardara en **`STK_LOAD_OFFSET`** lo que establece el valor de recarga del temporizador en 1000, este valor se puede cambiar según el intervalo de interrupción deseado. Luego colocamos un cero en **`STK_VAL_OFFSET`** para borrar su valor actual, se carga la dirección base del Registro de control del sistema **`SCB_BASE`** en r2 y luego se desplazan a la dirección del registro de prioridad de interrupción del sistema **`SCB_SHPR3_OFFSET`** en r2. Luego, se carga el valor **`0x20`** en r3 y se almacena en **`SCB_SHPR3_OFFSET`** para la interrupción SysTick, se cargan el valor actual del registro de control del temporizador de sistema **`SCB_CTRL_OFFSET`** en r1, y luego se realiza una operación OR con el valor 3 para habilitar el contador del temporizador de sistema y la interrupción del SysTick. Luego, se almacena el valor actualizado en el registro de control del temporizador de sistema.

 ### check_speed

Es la funcion que se encarga de ajustar la velocidad de un sistema en función de un valor pasado como argumento, consiste en un conjunto de condiciones que comparan speed con los valores 1, 2, 3 y 4, dependiendo sea el caso se retornan los valores 1000, 500, 250 y 125 respectivamente. Comienza con la condición de 1 a la 4 y se repite de nuevo el 1, ya que si se llega al numero maximo que en este caso es 4, la velocidad debe regresar a 1.

### delay

Esta función implementa un ciclo que se ejecuta hasta que el valor del registro r10 (pasado como parámetro) sea igual a cero. Esto provoca un retraso en la ejecución del programa ya que el bucle se repite hasta que se cumple la condición.

### exti_handler

Esta es la función del controlador de interrupciones externo, en este caso las interrupciones se recibirán a través de los pines **`PA10 y PA11`**, primero verifique si alguna interrupción está activada, como primer paso **` EXTI_BASE se inicializa `** , la dirección base del controlador de interrupción EXTI está en el registro r0, luego el contenido del registro **`EXTI_PR_OFFSET`** se carga en r0. Luego comparan r0 con 0x00000400, si son iguales saltan a **`exti_handler10`**, si no, pasan a la siguiente comprobación, que es comparar r0 con 0x00000800, y si es cierto saltan a **`exti_handler11`**, si no hay interrupciones activas, la función sale.

**`exti_handler10`** corresponde al manejo de la interrupción EXTI 10. Incrementa el valor de r8 en 1, luego carga la dirección base del controlador de interrupción EXTI en r0 y carga el contenido del registro **`EXTI_PR_OFFSET`** en r2. Luego, realiza una operación OR con **`0x400`** y almacena el resultado nuevamente en el registro **`EXTI_PR_OFFSET`**. Finalmente, se desvía a la etiqueta lr para salir de la función.

**`exti_handler11`**  corresponde al manejo de la interrupción EXTI 11. Realiza una operación XOR entre el valor de r9 y 1, lo que invierte el valor de r9. Luego realiza una operación AND entre r9 y **`0x1`** para asegurarse de que solo tenga el bit menos significativo activado. Luego carga la dirección base del controlador de interrupción EXTI en r0, carga el contenido del registro **`EXTI_PR_OFFSET`** en r2, realiza una operación OR con **`0x800`** y almacena el resultado nuevamente en el registro **`EXTI_PR_OFFSET`**. Finalmente, se desvía a la etiqueta lr para salir de la función.

### SysTick_Handler

Esta funcion corresponde al controlador de interrupción del temporizador de sistema (SysTick), esta funcion solo realiza un decremento en el valor del registro r10 en 1. Esta instrucción se utiliza para realizar seguimiento de la interrupción del temporizador de sistema.

## Compilacion

Para poder compilar el codigo previamente explicado y cargarlo a la blue pill se sigue la serie de pasos a continuación:

Se borran todos los archivos .o, .bin y . elf con el comando clean:

```nasm
    make clean
    make cleanwin
```

En el archivo MakeFile se modifica la linea 10 con los nombres de tus archivos .s que vas a compilar.
Se hace make para obtener los .o, .elf y .bin:

```nasm
    make 
```

Y se escribe con el siguiente comando, como observacion para escribir el microcontrolador el jumper debe estar en la esquina superior derecha.

```nasm
    make write
```

O con el STMCubeProgrammer

## Diagrama

![image](/CIRCUITO.png)
