
.section .text
.globl putstring

putstring:
	addi sp,sp,-8 # save ra on the stack
	sw   ra,0(sp)   # (need to do that for functions that call functions)
	sw   t2,4(sp)   # (need to do that for functions that call functions)
	add   t2,a0, zero	
.L1:    
    lbu  a0,0(t2)
	beqz a0,.L2
	call putchar
	addi t2,t2,1	
	j    .L1
.L2:
    lw t2,4(sp)  # restore ra
    lw ra,0(sp)  # restore ra
	addi sp,sp,8 # restore sp
	ret	