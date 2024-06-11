# data_mem(4)

li      $0, 0
li      $1, 1
li      $2, 64

li      $3, 0
outer:
bge     $3, $2, exit
addi    $4, $3, 1
inner:
bge     $4, $2, exit_inner
lw      $5, 0($3)
lw      $6, 0($4)
bge     $5, $6, skip
sw      $6, 0($3)
sw      $5, 0($4)
skip:
addi    $4, $4, 1
j       inner
exit_inner:
addi    $3, $3, 1
j       outer
exit:



