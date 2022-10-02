
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
    ldr r2, =gpio_dir //obtener direccion de gpio_state 
    ldr r3, =0xFFFFFFFF //preparando dato a escribir
    and r1, r1, r0 //solo tomar en cuenta 1's de la máscara 
    eor r3, r3, r0 //poner todos los campos correspondientes a pines como 0 
    orr r3, r3, r1 //finalizar valor a comparar 
    ldr r0, [r2]   //obtener valor de pines actual 
    
    //aplicar and a valor de gpios actual para obtener valor final
    and r0, r0, r3 
    str r0, [r2]
    bx lr

.global xgpio_put_masked
xgpio_set_put_masked:
    //r0 es la máscara de los pines
    //r1 es la máscara de valores
    ldr r2, =gpio_state //obtener direccion de gpio_state 
    ldr r3, =0xFFFFFFFF //preparando dato a escribir
    and r1, r1, r0 //solo tomar en cuenta 1's de la máscara 
    eor r3, r3, r0 //poner todos los campos correspondientes a pines como 0 
    orr r3, r3, r1 //finalizar valor a comparar 
    ldr r0, [r2]   //obtener valor de pines actual 
    
    //aplicar and a valor de gpios actual para obtener valor final
    and r0, r0, r3 
    str r0, [r2]
    bx lr

.global xgpio_get_all
xgpio_get_all:
    ldr r1, =gpio_state 
    ldr r0, [r1] 
    bx lr 


.data 
gpio_state: .word 0
gpio_dir: .word 0 