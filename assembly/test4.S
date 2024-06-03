    addi x12, x0, 0
    addi x13, x0, 20
    addi x14, x0, 0
    c.li x15, 1
    addi x16, x0, 1

stroe_loop:
    addi x12, x12, 1
    sw x15, 0(x14)
    sll x15, x15, x16
    addi x14, x14, 4
    blt x12, x13, stroe_loop


    addi x12, x0, 0
    addi x14, x0, 0
    addi x8, x0, 0
    addi x13, x13, -1

load_loop:
    c.addi x12, 1
    lw x15, 0(x14)
    addi x14, x14, 4
    c.xor x8, x15
    bge x13, x12, load_loop

    nop
    nop

