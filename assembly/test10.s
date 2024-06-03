    lui x1, 0x414e1
    addi x1, x1, 0x47b # 12.88
    # x1 = 1095636091

    lui x2, 0x40490
    addi x2, x2, 0x625 # 3.141
    # x2 = 1078527525

    fmv.w.x f1, x1
    fmv.w.x f2, x2

    fmul.s f10, f1, f2
    fmul.s f11, f1, f2

    fsqrt.s f12, f1
    # f12 = 33100.394121520665

    fsqrt.s f13, f2
    # f13 = 32840.94281533342

    fsw f13, 0(x0)
    flt.s x4, f1, f2
    flt.s x5, f2, f1
    lw x3, 0(x0)

    nop
    nop

