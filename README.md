# T3:Descripcion y Configuracion de puertos GPIO
---

## Contenido

1. Funcionamiento del programa
2. Compilacion
3. Diagrama de configuracion del hardware
---


## Funcionamiento del programa

### Main (Setup y Loop)

Primero al hacer la funcion haremos el **`setup`** en donde aparte de inicializar los inputs y outputs vamos a inicializar los interruptores primero siendo el EXTI en donde primero inicilizamos el AFIO_BASE y aparte de limpiar un registro este registro lo pondremos en  **`AFIO_EXTICR3_OFFSET`** para que lo seleccione en PA 11  y PA 10 leugo inicializamos los EXTI en donde cargaremos la base para luego cargar un numero que es para que carge el evento con PA 11 y 10 y luego los desmacaremos. Por iltimo activaremos el NVIC_BASE para atender la solicitud el EXTI por ultimo inicializamos Systick con Systick_Initialize.
Luego el main cargaremos el counter, speed y mode en registros superiores luego veremos la velocidades con check_speed y luego veremos si esta decendiendo o acendiendo el valor con mode por ultimo haremos el wait con el delay del speed y por utlimo haremos el output.

### check_speed

Esta funcion checa la velocidad que ira el delay en este caso cargaremos r5 (contiene speed) y lop compararemos en donde podria salir los siguientes resultados.
1. Si speed es 1 regresaremos un delay de 1000
2. Si speed es 2 regresaremos un delay de 500
3. Si speed es 3 regresaremos un delay de 250
4. Si speed es 4 regresaremos un delay de 125
5. Si no es ninguna de esas opciones speed sera 1 y regresamos 1000

### delay y SysTick_Initialize

En la funcion delay moveremos r0 (que es wait de la funcion main) y hara un loop en donde se compara con sero y continuara hasta que el wait sea igual 0 para luego volver.

En la funcion SysTick_Initialize vamos hacer el setup del SysTick primero inicializamos la base para que luego desactivemos el SysTick IRQ y el contadpr por lo que moveremos un cero a r1 y lo guardaremos en el **`STK_CTRL_OFFSET`** luego limpiraremos el valor del Systick en donde cargaremos un valor para que sea el intervalo y ese lo guardaremos en **`STK_LOAD_OFFSET`** luego limpiraremos el valor del Systick en donde pondremos un 0 en **`STK_VAL_OFFSET`**, luego ponemos la prioridad del Systick por lo que utilizamos SCB BASE y inizializamos SCB_SHPR3_OFFSET luego movemos 0x20 a r3 y lo ponemos en SCB_SHPR3_OFFSET por uytimo habilitamos el timer con SCB_CTRL_OFFSET y lo habilitamos con #7.

### EXI15_10_Handler

El EXTI handler que voy a utilizar va ser para el PA 10 y 11 por lo que primero inicializa el EXTI BASE y luego cargar el PR_OFFSET leugo cargamos el lugar donde esta EXTI10 y veremos si esta prendido si este prende iremops al **`EXTI10_Handler`** en donde vamos a sumar r5 (speed) lo guardamos en el PR_OFFSET y luego lo limpiamos para volverlo a guardar en caso que el EXTI10 no se presione vera si el EXTI11 si se presiono en caso que si entrara a **`EXTI11_Handler`** en donde hara negar el registro y luego hara un and para luego que gurade en PR_PFFSET en caso que tampoco este saltra de la interrupcion EXTI.

### SysTick_Handler

En este solo le resta 1 a r10 para que luego termines esta parte.

## Compilacion

Para poder compilar el código es necesario seguir los siguientes pasos:

1- En este caso utilizaremos el make para compilar en donde primero utilizaremos make clean para eliminar los viejos archivos:
```nasm
make clean
```
2- Despues vamos a utilizar make para crea el **`.elf`** y el **`.bin`**
```nasm
make
```
3-Por ultimo utlizaremos  **`make write`** para grabarlo en el st-link
```nasm
make write
```

## Diagrama de configuracion del hardware

En este diagrama los pines del A0-A7 son pines de salida mientras que del A10-A11 son pines de entrada

![image](https://github.com/RodrigoVegaUwu/Hacer-ReadME/assets/126529842/03375818-0541-4137-b870-ed34e83944e4)





