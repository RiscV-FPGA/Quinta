    addi x1, x0, 0

    c.li x8, 5
    c.li x9, 3
    c.add x9, x8
    c.addi x9, -2

    c.li x10, 15
    c.sub x9, x10

    c.slli x10, 1
    c.srli x9, 1

    c.li x15, 0
    c.sw x10, 0(x15)
    c.sw x9, 4(x15)

    c.addi x15, 4
    c.lw x11, 0(x15)
    lw x12, -4(x15)

    c.mv x13, x10
    c.sub x13, x12
    c.beqz x13, l
    addi x1, x1, 1
    addi x1, x1, 1
    addi x1, x1, 1

l:
    addi x1, x1, 0x123

    nop
    nop

