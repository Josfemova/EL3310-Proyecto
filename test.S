.equ LEDPIN, 25
.equ LOW, 0 
.equ HIGH, 1
.equ INPUT, 0
.equ OUTPUT, 1

.global main_asm
main_asm:
    push {r4,lr}

    ldr r0, =LEDPIN
    bl xgpio_init

    ldr r0, =LEDPIN 
    ldr r1, =OUTPUT
    
    bl xgpio_set_dir

    b while_1

    pop {r4,pc}
    b main_asm

while_1:
    bl led_off
    ldr r0, =250
    bl sleep 
    bl led_on
    ldr r0, =1000
    bl sleep  
    b while_1

.global led_on
led_on:
    push {r4,lr}
    movs r0, #LEDPIN 
    movs r1, #HIGH
    bl xgpio_put 
    pop {r4,pc}


.global led_off
led_off:
    push {r4,lr}
    movs r0, #LEDPIN 
    movs r1, #LOW 
    bl xgpio_put
    pop {r4,pc}


.global sleep
sleep:
    push {r4,lr}
    bl sleep_ms
    pop {r4,pc}