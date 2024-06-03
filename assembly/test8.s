
    lui x1, 0xa9876
    addi x1, x1, 0x543

    sw x1, 0(x0)

    lb x2, 0(x0)
    lb x3, 1(x0)
    lb x4, 2(x0)
    lb x5, 3(x0)

    lbu x6, 2(x0)

    lh x7, 0(x0)
    lh x8, 2(x0)

    lhu x9, 2(x0)

    lw x10, 0(x0)

    sb x2, 4(x0)
    sb x3, 5(x0)
    sh x8, 6(x0)

    lw x11, 4(x0)

    nop
    nop
    nop