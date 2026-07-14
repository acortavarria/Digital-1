    .section .text
.globl get_number

get_number:
    addi sp, sp, -16        # Reservar espacio en stack
    sw ra, 12(sp)           # Guardar return address
    sw s0, 8(sp)            # Guardar s0 (acumulador)
    sw t0, 4(sp)            # Guardar s2 (primer dígito)
    sw t1, 0(sp)            # Guardar s2 (primer dígito)
    
    li s0, 0                # s0 = acumulador (resultado)
    
get_number_loop:
    call getchar         # Leer carácter en a0
    add t6, a0, zero               # Guardar carácter en t6
    call putchar         # a0 ya contiene el carácter
    
    add a0, t6, zero               # Restaurar carácter para procesamiento
    
    # Verificar si es newline o enter (terminar)
    li t0, 10               # '\n'
    beq a0, t0, get_number_done
    li t0, 13               # '\r'
    beq a0, t0, get_number_done
    
    # Verificar si es espacio (terminar)
    li    t0, 32               # ' '
    beq   a0, t0, get_number_done
    # Verificar si es dígito ('0'-'9')
    li    t0, 48               # '0'
    blt   a0, t0, get_number_loop  # Si < '0', ignorar
    li    t0, 57               # '9'
    bgt   a0, t0, get_number_loop  # Si > '9', ignorar
    
    # Convertir ASCII a número
    andi  a0, a0, 15

    # correr 4 posiciones: s0 = s0 << 4
    add    t1, s0, zero               # t1 = s0
    slli  s0, s0, 4
    
    # Sumar nuevo dígito
    or    s0, s0, a0
    j     get_number_loop       # Continuar leyendo
    
get_number_done:
    add    a0, s0, zero               # Retornar resultado en a0
    
    # Restaurar registros
    lw    t1, 0(sp)
    lw    t0, 4(sp)
    lw    s0, 8(sp)
    lw    ra, 12(sp)
    addi  sp, sp, 16
    ret