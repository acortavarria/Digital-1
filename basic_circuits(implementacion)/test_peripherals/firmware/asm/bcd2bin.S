.equ BCD2BIN_BASE,   0x460000  
.equ BCD2BIN_OP_A,   0x04
.equ BCD2BIN_INIT,   0x0C
.equ BCD2BIN_RESULT, 0x10
.equ BCD2BIN_DONE,   0x14

.section .text
.globl bcd2bin

# a0

#li   a0, 33333   # se debe quitar después de la prueba

bcd2bin:
  addi sp, sp, -12        # Reservar espacio en stack
  sw ra, 8(sp)           # Guardar return address
  sw t0, 4(sp)            # Guardar t0 (acumulador)
  sw t1, 0(sp)            # Guardar t1 (signo)

  li   gp, BCD2BIN_BASE 
  sw   a0, BCD2BIN_OP_A(gp)  
  li   a0, 1
  sw   a0,   BCD2BIN_INIT(gp) 
  sw   zero, BCD2BIN_INIT(gp)  
.L0:
  li   t0, 1  
  lw   t1, BCD2BIN_DONE(gp)
  and  t1, t1, t0
  beq  t1, zero, .L0  
  lw   a0, BCD2BIN_RESULT(gp)

  
  lw t1, 0(sp)            # Guardar t1 (signo)
  lw t0, 4(sp)            # Guardar t0 (acumulador)
  lw ra, 8(sp)           # Guardar return address
  addi sp, sp, 12
  ret
