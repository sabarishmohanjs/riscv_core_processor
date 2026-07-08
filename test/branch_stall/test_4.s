//continuos branching statement
addi x1, x0, 5
addi x2, x0, 5

beq x1,x2,L1
addi x3,x0,1

L1:
beq x1,x2,L2
addi x4,x0,2

L2:
addi x5,x0,3