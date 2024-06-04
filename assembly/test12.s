
    addi x1, x1, -1

    lui x2, 0x11111
    addi x2, x2, 0x333

    sw x1, 0(x0)
    nop
    sh x2, 2(x0)

    lw x10, 0(x0)

    nop
    nop
    nop