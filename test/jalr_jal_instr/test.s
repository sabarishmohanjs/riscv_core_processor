addi x1,x0,5

jal  x2,TARGET

addi x3,x0,111          # flushed
addi x4,x0,222          # flushed

TARGET:

addi x5,x0,99

add  x6,x2,x1           # verifies link register

auipc x7,0
addi  x7,x7,12

jalr  x8,x7,0

addi x9,x0,111          # flushed
addi x10,x0,222         # flushed

DEST:

addi x11,x0,88


jal x12,FUNC

addi x13,x0,55

END:
nop
nop
nop

FUNC:

addi x14,x0,33

