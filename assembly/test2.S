    lui x8, 0x80000
    addi x8, x8, 0x000

    lui x9, 0xffff
    c.li x9, 15

loop:
    addi x9, x9, -1
    c.srai x8, 1
    nop
    c.bnez x9, loop

    nop
    nop

