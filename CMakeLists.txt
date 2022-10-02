cmake_minimum_required(VERSION 3.13)
include(pico_sdk_import.cmake)
project(semaforo_project C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
pico_sdk_init()

add_executable(semaforo
  rp2040_port.c
  main.S
)

pico_add_extra_outputs(semaforo)
target_link_libraries(semaforo pico_stdlib hardware_gpio)
