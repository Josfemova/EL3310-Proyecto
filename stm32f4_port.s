
.equ PINS,       0b111101111100011111
.equ OUTPUT_PINS,0b000001111100011111
.equ INPUT_PINS, 0b111100000000000000

.global xgpio_init_mask 
xgpio_init_mask:    
    //no es necesario hacer algo aquí en simulación
    ldr r0, =gpio_state 
    ldr r1, =INPUT_PINS
    ldr r2, [r1]
    str r2, [r0]
    bx lr

.global xgpio_set_dir_masked
xgpio_set_dir_masked:
    //r0 es la máscara de los pines
    //r1 es la máscara de direcciones
    ldr r2, =gpio_dir //obtener direccion de gpio_dir
    ldr r3, [r2]   //cargar valor de pines a r3
    eor r3, r3, r0 //aplicar 0's en pines a cambiar
    and r1, r1, r0 //aplicar 0's en valores fuera de máscara
    orr r1, r1, r3 //aplicar valores a forzar en el valor de pines a guardar
    str r1, [r2]  //guardar el valor final en gpio_dir 
    bx lr

.global xgpio_put_masked
xgpio_put_masked:
    //r0 es la máscara de los pines
    //r1 es la máscara de valores
    ldr r2, =gpio_state //obtener direccion de gpio_state 
    ldr r3, [r2]   //cargar valor de pines a r3
    eor r3, r3, r0 //aplicar 0's en pines a cambiar
    and r1, r1, r0 //aplicar 0's en valores fuera de máscara
    orr r1, r1, r3 //aplicar valores a forzar en el valor de pines a guardar
    str r1, [r2]  //guardar el valor final en gpio_state 
    bx lr

.global xgpio_get_all
xgpio_get_all:
    ldr r1, =gpio_state 
    ldr r0, [r1] 
    bx lr 


.data 
gpio_state: .word 0
gpio_dir: .word 0 
