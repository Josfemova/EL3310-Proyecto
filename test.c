#include "hardware/gpio.h"

const uint LED_PIN = 25;

void xgpio_init(unsigned int pin){
    gpio_init(pin);        
}
void xgpio_set_dir(unsigned int pin, int dir){
    gpio_set_dir(pin, dir);
}
void xgpio_put(unsigned int pin, int value){
    gpio_put(pin, value);
}
void xsleep(int ms){
    sleep_ms(ms);
}

extern int main_asm();

int main(){
    main_asm();
}