#include "hardware/gpio.h"
#include "pico/stdlib.h"
#include <stdio.h>

void xgpio_init_mask(unsigned int pins){
    printf("init mask: %d\n", pins);
    gpio_init_mask(pins);        
}
void xgpio_set_dir_masked(uint32_t pins, uint32_t value){
    printf("pins config: %d\n", pins);
    gpio_set_dir_masked(pins, value);
}
void xgpio_put_masked(unsigned int pins, int value){
    printf("put mask: %d  -- val : %d\n", pins, value);
    gpio_put_masked(pins, value);
}
uint32_t xgpio_get_all(){
    uint32_t result = gpio_get_all();
    printf("gpio_status: %x\n", result);
    return result;
}
void xsleep(int ms){
    sleep_ms(ms);
}

void hemlo(int a){
    printf("hemlo %d\n",a);
}

extern void xisr_systick();
extern void isr_systick(){
    xisr_systick();
}

extern int main_asm();

int main(){
    stdio_init_all();
    main_asm();
}