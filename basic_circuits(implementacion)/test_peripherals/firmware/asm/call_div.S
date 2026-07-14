.section .text

loopM:

li   sp,0x2000

    li   a0, 2048
    li   a1, 64
    call div
    j    loopM