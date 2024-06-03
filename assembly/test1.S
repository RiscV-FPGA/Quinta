    lui x2, 0x87654
    addi x2, x2, 0x321

    addi x1, x0, 4
    sw x2, 4(x1)

    add x9, x0, x0
    c.lw x8, 8(x9)

    add x10, x8, x8

    nop
    nop

