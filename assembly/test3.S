    lui x20, 0xfedcc
    addi x20, x20, 0x000
    addi x20, x20, -1384

    c.li x21, 6
    add x22, x21, x20
    sub x23, x20, x22
    c.mv x24, x23
    sub x24, x0, x24

    nop
    nop

