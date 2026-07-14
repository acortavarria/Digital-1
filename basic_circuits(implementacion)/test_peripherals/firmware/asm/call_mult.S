.section .text

loopM:

li   sp,1024

    li   a0, 12
    li   a1, 12
    call mult
    j    loopM
