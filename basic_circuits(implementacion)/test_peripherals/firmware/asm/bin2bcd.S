.equ BIN2BCD_BASE,   0x440000  
.equ BIN2BCD_OP_A,   0x04
.equ BIN2BCD_INIT,   0x0C
.equ BIN2BCD_RESULT, 0x10
.equ BIN2BCD_DONE,   0x14

.section .text
.globl bin2bcd

# a0

#li   a0, 33333   # se debe quitar después de la prueba

bin2bcd:
  addi sp, sp, -16        # Reservar espacio en stack
  sw ra, 12(sp)           # Guardar return address
  sw t0, 8(sp)            # Guardar t0 (acumulador)
  sw t1, 4(sp)            # Guardar t1 (signo)
  sw t3, 0(sp)            # Guardar t1 (signo)

  li   gp, BIN2BCD_BASE 
  sw   a0, BIN2BCD_OP_A(gp)  
  li   a0, 1
  sw   a0,   BIN2BCD_INIT(gp) 
  sw   zero, BIN2BCD_INIT(gp)  
.L0:
  li   t0, 1  
  lw   t1, BIN2BCD_DONE(gp)
  and  t1, t1, t0
  beq  t1, zero, .L0  
  lw   a0, BIN2BCD_RESULT(gp)
#
#  print result
  add   a1, a0, zero
	li   a0,10
	call putchar  
	li   a0,13
	call putchar
  
  add   a0, a1, zero
  li   t3, 0x10       # 2 ^ bits to send  
.L5:
  add   t0, a1, zero
  srli t0, t0, 16
  andi t0, t0, 0x0F
  addi t0, t0, 0x30
  add   a0, t0, zero
  call putchar
  slli a1, a1, 4
  srli t3, t3, 1
  beqz t3, .PC0
  j    .L5
.PC0: 
  li   a0,10
  call putchar
  li   a0,13
  call putchar   

  lw t3, 0(sp)            # Guardar t1 (signo) 
  lw t1, 4(sp)            # Guardar t1 (signo)
  lw t0, 8(sp)            # Guardar t0 (acumulador)
  lw ra, 12(sp)           # Guardar return address
  addi sp, sp, 16
  
  ret