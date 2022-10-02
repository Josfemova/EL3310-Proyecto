.equ SYSTICK_BASE_CSR,   0xe000e010
.equ SYSTICK_RVR_OFFSET, 0x4
.equ SYSTICK_CVR_OFFSET, 0x8


//valores generales
.equ LOW,    0 
.equ HIGH,   1
.equ INPUT,  0
.equ OUTPUT, 1

.equ PINS         , 0b111101111100011111 // hexa: 0x03df1f
.equ OUTPUT_PINS  , 0b000001111100011111 // hexa: 0x001f1f
.equ INPUT_PINS   , 0b111100000000000000 // hexa: 0x03c000
.equ MASK_GRRR    , 0b000000010100010001 // hexa: 0x000511
.equ MASK_YRRR    , 0b000000010100001001 // hexa: 0x000509
.equ MASK_RGRG    , 0b000001001000000101 // hexa: 0x001205
.equ MASK_GRGR    , 0b000000010100010010 // hexa: 0x000512
.equ MASK_RYRR    , 0b000000100100000101 // hexa: 0x000905
.equ MASK_RGRR    , 0b000001000100000101 // hexa: 0x001105
.equ MASK_PIN_IRNS, 0b000100000000000000 // hexa: 0x004000
.equ MASK_PIN_IREW, 0b001000000000000000 // hexa: 0x008000
.equ MASK_PIN_BNS , 0b010000000000000000 // hexa: 0x010000
.equ MASK_PIN_BEW , 0b100000000000000000 // hexa: 0x020000

.equ OFFSET_PIN_IRNS, 14
.equ OFFSET_PIN_IREW, 15
.equ OFFSET_PIN_BNS , 16 
.equ OFFSET_PIN_BEW , 17

.equ SEG_5 , 5000
.equ SEG_15, 15000
.equ SEG_55, 55000

.global sleep
sleep: //esperar por la cantidad de milisegundos dados en r0
    push {r4, lr}
    mov r4, r0
    bl reset_counter 
    ldr r1, =counter
    
    sleep_loop: 
        ldr r2, [r1]
        cmp r2, r4 
        bmi sleep_loop 

    pop {r4, pc}


.global init_systick
init_systick:
    push {r4,lr}
    ldr r0, =0 
    ldr r1, =125000 
    ldr r2, =0b111
    ldr r3, =SYSTICK_BASE_CSR
    str r0, [r3]                       //desactivar systick antes de configurar
    str r1, [r3, #SYSTICK_RVR_OFFSET]  //Valor de recarga (125MHz)/(valor +1) = 1ms
    str r0, [r3, #SYSTICK_CVR_OFFSET]  //Forzar recarga de 0
    str r2, [r3]                       //Activar timer, interrupción y source de clk es el proce
    pop {r4,pc}

.global xisr_systick //manejo de la interrupcion
xisr_systick:
    push {r4, lr}
    ldr r0, =counter
    ldr r1, [r0]
    add r1, r1, #1
    str r1, [r0]
    pop {r4, pc} 

.global reset_counter
reset_counter:
    ldr r0, =counter
    ldr r1, =0
    str r1, [r0]
    bx lr 

.global main_asm
main_asm:
    bl init_systick
    ldr r0, =PINS
    bl xgpio_init_mask

    ldr r0, =OUTPUT_PINS
    ldr r1, =OUTPUT_PINS
    bl xgpio_set_dir_masked

    ldr r0, =INPUT_PINS
    ldr r1, =0
    bl xgpio_set_dir_masked

    b state00_RYRR

state00_RYRR:
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_RYRR
    bl xgpio_put_masked
    
    //esperar por 5 segundos
    ldr r0, =SEG_5 
    bl sleep 

    b state01_GRRR


state01_GRRR:
    bl reset_counter
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_GRRR
    bl xgpio_put_masked
    state01_GRRR_checks:
        bl xgpio_get_all //r0 se queda con el estado de pines
        
        //check B_EW
        ldr r1, =MASK_PIN_BEW
        and r1, r1, r0 //aplicar máscara para solo dejar ese pin 
        ldr r2, =MASK_PIN_BEW
        cmp r2, r1  //si mascara y resultado son iguales el pin está en 1
        bne state02_YRRR_BEW

        //check IR_NS
        ldr r1, =MASK_PIN_IRNS 
        and r1, r1, r0 
        ldr r2, =MASK_PIN_IRNS 
        cmp r2, r1 
        bne state04_YRRR

        //check t
        ldr r0, =counter 
        ldr r1, [r0]
        ldr r2, =SEG_55 //55 segundos
        cmp r1, r2
        bpl state04_YRRR 

        //return to check
        b state01_GRRR_checks


state02_YRRR_BEW:
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_YRRR
    bl xgpio_put_masked

    //esperar por 5 segundos
    ldr r0, =SEG_5 
    bl sleep 

    b state03_RGRG

state03_RGRG:
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_RGRG
    bl xgpio_put_masked

    //esperar por 5 segundos
    ldr r0, =SEG_15 
    bl sleep 

    b state00_RYRR

state04_YRRR:
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_YRRR
    bl xgpio_put_masked

    //esperar por 5 segundos
    ldr r0, =SEG_5
    bl sleep 

    b state05_RGRR

state05_RGRR:
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_RGRR
    bl xgpio_put_masked
    state05_RGRR_checks:
        bl xgpio_get_all //r0 se queda con el estado de pines
        
        //check B_NS
        ldr r1, =MASK_PIN_BNS
        and r1, r1, r0 //aplicar máscara para solo dejar ese pin 
        ldr r2, =MASK_PIN_BNS
        cmp r2, r1  //si mascara y resultado son iguales el pin está en 1
        bne state06_RYRR_BNS

        //check IR_EW
        ldr r1, =MASK_PIN_IREW 
        and r1, r1, r0 
        ldr r2, =MASK_PIN_IREW 
        cmp r2, r1 
        bne state00_RYRR

        //check t
        ldr r0, =counter 
        ldr r1, [r0]
        ldr r2, =SEG_55 //55 segundos
        cmp r1, r2
        bpl state00_RYRR

        //return to check
        b state05_RGRR_checks

state06_RYRR_BNS:
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_RYRR
    bl xgpio_put_masked

    //esperar por 5 segundos
    ldr r0, =SEG_5
    bl sleep 

    b state07_GRGR

state07_GRGR:
    ldr r0, =OUTPUT_PINS
    ldr r1, =MASK_GRGR
    bl xgpio_put_masked

    //esperar por 15 segundos
    ldr r0, =SEG_15
    bl sleep 

    b state04_YRRR


.data 
counter: .word 0