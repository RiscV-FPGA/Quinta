# Finds sum of the first N numbers recursively.

# x1: Return Address
# x30: Stack Pointer
# x10 : n but also sum function's return value

main:
    addi x10, x0, 1        # n
    jalr x1, 12             # Sum(n)
    jalr x1, 24

SUM:
    sw x1, 0(x30)           # Save return address on stack
    sw x10, 4(x30)          # Save argument n
    addi x30, x30, 8        # Adjust stack pointer

    addi x11, x10, -1       # x11 = n - 1
    nop
    nop
    bge x11, x0, RECUR      # if (n - 1) >= 0 then do a recursive call
    addi x10, x0, 0         # Return 0 (base case)
    addi x30, x30, -8       # Pop 2 items
    ret
RECUR:
    addi x10, x10, -1       # n - 1
    jalr x1, SUM             # Sum(n-1)
    addi x20, x10, 0        # x20 = rsult of sum. i.e. x20 = Sum(n - 1)
    addi x30, x30, -8       # Adjust the stack
    lw x10, 4(x30)          # Restore n
    lw x1, 0(x30)           # Restore return address
    add x10, x10, x20       # x10 = n + sum(n - 1)
    nop
    nop
    ret                     # return x10

END:
nop
nop

