# Load values to x registers
addi x1, x0, 1
addi x2, x0, 15
addi x3, x0, 10
addi x4, x0, -10

# Int to Float
fmv.w.x f0, x0
fmv.w.x f1, x1
fmv.w.x f2, x2
fmv.w.x f3, x3
fmv.w.x f4, x4

# Float to Int
fmv.x.w x10, f0
fmv.x.w x11, f1
fmv.x.w x12, f2
fmv.x.w x13, f3
fmv.x.w x14, f4

# Float add sub
fadd.s f6, f2, f3, rne
fsub.s f7, f2, f3, rne
fsub.s f8, f3, f2, rne

# Float add sub
fadd.s f6, f2, f3, rne
fsub.s f7, f2, f3, rne
fsub.s f8, f3, f2, rne

# Float store Load
fsw f2, 4(x0)
flw f31, 4(x0)

# Float compare (eq, lt, lteq)
feq.s x24, f2, f31
feq.s x25, f2, f3 
flt.s x26, f3, f2
flt.s x28, f2, f31
flt.s x27, f2, f3
fle.s x29, f3, f2
fle.s x30, f2, f31
fle.s x31, f2, f3

# Float mul
fmul.s f10, f2, f3
fmul.s f11, f10, f2
fmul.s f12, f11, f10
fmul.s f13, f12, f11
fmul.s f14, f13, f12
fmul.s f15, f14, f13
fmul.s f16, f3, f3
fmul.s f17, f2, f2

# Float div
fdiv.s	f19, f2, f3, rne
fdiv.s	f20, f10, f3, rne

# Float sqrt
fsqrt.s f22, f16, rne
nop
fsqrt.s f23, f17, rne
fsqrt.s f24, f10, rne
