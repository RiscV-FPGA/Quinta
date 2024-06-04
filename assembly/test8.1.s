
    lui x1, 0xa9876
    addi x1, x1, 0x543

    sw x1, 0(x0)

    lb x2, 0(x0)
    lb x3, 1(x0)
    lb x4, 2(x0)
    lb x5, 3(x0)

    lbu x7, 0(x0)
    lbu x8, 1(x0)
    lbu x9, 2(x0)
    lbu x10, 3(x0)

    lh x12, 0(x0)
    lh x13, 2(x0)
    
    lhu x15, 0(x0)
    lhu x16, 2(x0)

    sb x1, 8(x0)
    sb x1, 13(x0)
    sb x1, 18(x0)
    sb x1, 23(x0)

    sh x1, 28(x0)
    sh x1, 34(x0)

    nop
    nop
    nop