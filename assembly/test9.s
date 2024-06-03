    lui x1, 0x12345
    addi x1, x1, 0x543
    # x1 = 305419587

    lui x2, 0x54321
    addi x2, x2, 0x678
    # x2 = 1412568696

    mul x3, x1, x2
    # x3 = -1426998936
    mulh x4, x1, x2
    # x4 = 100449227

    lui x5, 0
    addi x5, x5, 156

    div x6, x1, x5
    # x6 = 1957817
    rem x7, x1, x5
    # x7 = 135

    addi x8, x0, -15
    addi x9, x0, 4

    mul x10, x8, x9
    # x10 = -60

    div x11, x8, x9
    # x11 = -3
    
    divu x12, x8, x9
    # x12 = 1073741820
    
    rem x13, x8, x9
    # x11 = -3
    
    remu x14, x8, x9
    # x14 = 1

    nop
    nop
    nop