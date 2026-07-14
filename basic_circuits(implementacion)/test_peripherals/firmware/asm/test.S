.equ TEST_BASE,   0x420000  
.equ TEST_OP_A,   0x04
.equ TEST_OP_B,   0x08
.equ TEST_INIT,   0x0C
.equ TEST_RESULT, 0x10
.equ TEST_DONE,   0x14

.section .text
.globl test
# a0 * a1
  
test:
  li   gp, TEST_BASE 
  sw   a0, TEST_OP_A(gp)  
  sw   a1, TEST_OP_B(gp)
  li   a0, 1
  sw   a0, TEST_INIT(gp) 
  sw   zero, TEST_INIT(gp)  
.L0:
   li   t0, 1  
   lw   t1, TEST_DONE(gp)
   and  t1, t1, t0
   beqz t1, .L0  
   lw   a0, TEST_RESULT(gp)
  ret