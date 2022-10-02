.equ SYSTICK_BASE_CSR, 0xe000e010
.equ SYSTICK_RVR_OFFSET, 0x4
.equ SYSTICK_CVR_OFFSET, 0x8


//valores generales
.equ LOW, 0 
.equ HIGH, 1
.equ INPUT, 0
.equ OUTPUT, 1

.equ PINS, 0b111101111100011111
.equ OUTPUT_PINS, 0b1111100011111
.equ INPUT_PINS, 0b111100000000000000
.equ MASK_GRRR, 0b10100010001
.equ MASK_YRRR, 0b10100001001
.equ MASK_RGRG, 0b1001000000101
.equ MASK_GRGR, 0b10100010010
.equ MASK_RYRR, 0b100100000101
.equ MASK_RGRR, 0b1000100000101


.global sleep
sleep:
    push {lr}
    bl sleep_ms
    pop {pc}

.global init_systick
init_systick:
    push {lr}
    ldr r0, =0 
    ldr r1, =124999999
    ldr r2, =0b111
    ldr r3, =SYSTICK_BASE_CSR
    str r0, [r3]                       //desactivar systick antes de configurar
    str r1, [r3, #SYSTICK_RVR_OFFSET]  //Valor de recarga (125MHz)/(valor +1) = 1ms
    str r0, [r3, #SYSTICK_CVR_OFFSET]  //Forzar recarga de 0
    str r2, [r3]                       //Activar timer, interrupción y source de clk es el proce
    pop {pc}

.global xisr_systick //manejo de la interrupcion
xisr_systick:
    push {r4, lr}
    ldr r4, =counter 
    ldr r0, [r4]
    bl hemlo
    ldr r0, =counter
    ldr r1, [r0]
    add r1, r1, #1
    str r1, [r0]
    pop {r4, pc} 

.global reset_counter
reset_counter:
    push {lr}

    ldr r0, =counter
    ldr r1, =0
    str r1, [r0]

    pop {pc}

.global main_asm
main_asm:
    bl init_systick
    ldr r0, =2000
    bl sleep
    ldr r0, =PINS
    bl xgpio_init_mask

    ldr r0, =OUTPUT_PINS
    ldr r1, =OUTPUT_PINS
    bl xgpio_set_dir_masked

    ldr r0, =INPUT_PINS
    ldr r1, =0
    bl xgpio_set_dir_masked

    b loop

loop:
    bl state00_RYRR 
    ldr r0, =1000
    bl sleep 
    bl state01_GRRR
    ldr r0, =1000
    bl sleep 
    bl state02_YRRR_bew
    ldr r0, =1000
    bl sleep 
    bl state03_RGRG
    ldr r0, =1000
    bl sleep 
    bl state04_YRRR
    ldr r0, =1000
    bl sleep 
    bl state05_RGRR
    ldr r0, =1000
    bl sleep 
    bl state06_RYRR_BNS
    ldr r0, =1000
    bl sleep 
    b loop

state00_RYRR:
    push {lr}
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_RYRR
    bl xgpio_put_masked
    pop {pc}

state01_GRRR:
    push {lr}
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_GRRR
    bl xgpio_put_masked
    pop {pc}

state02_YRRR_bew:
    push {lr}
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_YRRR
    bl xgpio_put_masked
    pop {pc}

state03_RGRG:
    push {lr}
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_RGRG
    bl xgpio_put_masked
    pop {pc}

state04_YRRR:
    push {lr}
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_YRRR
    bl xgpio_put_masked
    pop {pc}

state05_RGRR:
    push {lr}
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_RGRR
    bl xgpio_put_masked
    pop {pc}

state06_RYRR_BNS:
    push {lr}
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_RYRR
    bl xgpio_put_masked
    pop {pc}


.data 
gpio_state: .word 0
input_state: .word 0 
counter: .word 0