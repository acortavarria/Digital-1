.equ MULT_BASE,   0x420000  
.equ MULT_OP_A,   0x04
.equ MULT_OP_B,   0x08
.equ MULT_INIT,   0x0C
.equ MULT_RESULT, 0x10
.equ MULT_DONE,   0x14

.section .text
.globl mult_hw
# a0 * a1

#li a0, 122     #  colocar como comentario después de la prueba
#li a1, 144     #  colocar como comentario después de la prueba
  
mult_hw:
  li   gp, MULT_BASE 
  sw   a0, MULT_OP_A(gp)  
  sw   a1, MULT_OP_B(gp)
  li   a0, 1
  sw   a0, MULT_INIT(gp) 
  sw   zero, MULT_INIT(gp)  
.L0:
  li   t0, 1  
  lw   t1, MULT_DONE(gp)
  and  t1, t1, t0
  beqz t1, .L0  
  lw   a0, MULT_RESULT(gp)
  ret
