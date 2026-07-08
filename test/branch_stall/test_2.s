//branch beq not taken

addi x1, x0, 5
addi x2, x0, 8
beq  x1, x2, target
addi x3, x0, 111
addi x4, x0, 222

target:
addi x5, x0, 99