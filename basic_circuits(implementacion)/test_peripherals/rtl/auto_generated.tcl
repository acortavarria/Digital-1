# Script TCL generado automáticamente desde Makefile
# Fecha: jue 09 jul 2026 02:22:02 -05

# Configurar dispositivo
set_device -name GW5A-25A GW5A-LV25MG121NES

add_file sipeed_tang_primer_25k.cst
add_file sipeed_tang_primer_25k.sdc
# Agregar archivos fuente
add_file -type verilog cores/cpu/femtorv32_quark_V2.v
add_file -type verilog cores/uart/perip_uart.v
add_file -type verilog cores/uart/uart.v
add_file -type verilog cores/bin2bcd/add_sub_c2.v
add_file -type verilog cores/bin2bcd/bin2bcd.v
add_file -type verilog cores/bin2bcd/mux2.v
add_file -type verilog cores/bin2bcd/count.v
add_file -type verilog cores/bin2bcd/ctrl_b2b.v
add_file -type verilog cores/bin2bcd/perip_bin2bcd.v
add_file -type verilog cores/bin2bcd/lsr4.v
add_file -type verilog cores/bin2bcd/reg_msb.v
add_file -type verilog cores/bcd2bin/bcd2bin.v
add_file -type verilog cores/bcd2bin/perip_bcd2bin.v
add_file -type verilog cores/bcd2bin/rsr4.v
add_file -type verilog cores/bram/bram.v
add_file -type verilog cores/test/perip_test.v
add_file -type verilog cores/test/RaizCuadrada/contador.v
add_file -type verilog cores/test/RaizCuadrada/fsm.v
add_file -type verilog cores/test/RaizCuadrada/comparador.v
add_file -type verilog cores/test/RaizCuadrada/RaizCuadrada.v
add_file -type verilog cores/test/RaizCuadrada/RegistroAext2.v
add_file -type verilog cores/test/RaizCuadrada/RegistroC.v
add_file -type verilog cores/test/RaizCuadrada/SumadorRestador17_C2.v
add_file -type verilog SOC.v

# Configurar opciones del proyecto
set_option -use_mspi_as_gpio 1
set_option -use_i2c_as_gpio 1
set_option -use_ready_as_gpio 1
set_option -use_done_as_gpio 1
set_option -use_cpu_as_gpio 1
set_option -rw_check_on_ram 1
run all
