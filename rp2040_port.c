#include "hardware/gpio.h"
#include "pico/stdlib.h"
#include <stdio.h>

void xgpio_init_mask(uint32_t pins) { gpio_init_mask(pins); }
void xgpio_set_dir_masked(uint32_t pins, uint32_t value) { gpio_set_dir_masked(pins, value); }
void xgpio_put_masked(uint32_t pins, int value) { gpio_put_masked(pins, value); }
uint32_t xgpio_get_all() { return gpio_get_all(); }

extern void xisr_systick();
extern void isr_systick() { xisr_systick(); }

extern int main_asm();
int main() { main_asm(); }