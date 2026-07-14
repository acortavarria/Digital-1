.equ SQRT_BASE,   0x410000  
.equ SQRT_OP_A,   0x04
.equ SQRT_INIT,   0x0C
.equ SQRT_RESULT, 0x10
.equ SQRT_DONE,   0x14

.section .text
.globl sqrt

# a0

#li   a0, 169   # se debe quitar después de la prueba

sqrt:
	addi sp,sp,-4 # save ra on the stack
	sw   ra,0(sp)   # (need to do that for functions that call functions)
  li   gp, SQRT_BASE 
  sw   a0, SQRT_OP_A(gp)  
  li   a0, 1
  sw   a0,   SQRT_INIT(gp) 
  sw   zero, SQRT_INIT(gp)
.L0:
  li   t0, 1  
  lw   t1, SQRT_DONE(gp)
  and  t1, t1, t0
  beq  t1, zero, .L0  
  lw   a0, SQRT_RESULT(gp)
  lw   ra,0(sp)  # restore ra
	addi sp,sp,4 # restore sp
  ret
