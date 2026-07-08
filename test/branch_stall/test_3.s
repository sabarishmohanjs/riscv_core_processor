//forwarding + branch stalling
addi x1, x0, 5
addi x2, x0, 5
add  x3, x1, x2
addi x4, x0, 10
beq  x3, x4, target
addi x5, x0, 123
addi x6, x0, 234

target:
addi x7, x0, 99