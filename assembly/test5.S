    lui x8, 0x55555
    lui x9, 0x22222
    or x10, x8, x9

    ori x1, x0, 1
    slli x1, x1, 31
    or x10, x10, x1
    srai x11, x10, 12

    lui x2, 0x00075
    addi x2, x2, 0x0f3

    and x12, x11, x2

    lui x13, 0x00075
    addi x13, x13, 0x75

    slt x3, x12, x13
    and x4, x12, x13
    andi x5, x4, 0x345

    nop
    nop

