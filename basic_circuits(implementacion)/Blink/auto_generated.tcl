# Script TCL generado automáticamente desde Makefile
# Fecha: jue 25 jun 2026 23:24:02 -05

# Configurar dispositivo
set_device -name GW5A-25A GW5A-LV25MG121NC1/I0

add_file sipeed_tang_primer_25k.cst
add_file sipeed_tang_primer_25k.sdc
# Agregar archivos fuente
add_file -type verilog blink.v

# Configurar opciones del proyecto
set_option -use_mspi_as_gpio 1
set_option -use_i2c_as_gpio 1
set_option -use_ready_as_gpio 1
set_option -use_done_as_gpio 1
set_option -use_cpu_as_gpio 1
set_option -rw_check_on_ram 1
run all
