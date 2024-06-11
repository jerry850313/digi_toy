# data_mem(1)

li      $0, 0
li      $1, 1
li      $2, 9
li      $6, 0

li      $3, 1
outer:
bge     $3, $2, exit
li      $4, 1
li      $5, 0
inner:
bge     $4, $2, exit_inner
add     $5, $5, $3
sw      $5, 0($6)
addi    $6, $6, 1
addi    $4, $4, 1
j       inner
exit_inner:
addi    $3, $3, 1
j       outer
exit:



