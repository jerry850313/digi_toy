# data_mem(1)

li      $0, 0
li      $1, 0

sw      $1, 0($0)
addi    $1, $1, 1
sw      $1, 1($0)
addi    $1, $1, 1
sw      $1, 2($0)
addi    $1, $1, 1
sw      $1, 3($0)
addi    $1, $1, 1
sw      $1, 4($0)
addi    $1, $1, 1
sw      $1, 5($0)
addi    $1, $1, 1
sw      $1, 6($0)
addi    $1, $1, 1
sw      $1, 7($0)

sw      $1, 8($0)
addi    $1, $1, -1
sw      $1, 9($0)
addi    $1, $1, -1
sw      $1, 10($0)
addi    $1, $1, -1
sw      $1, 11($0)
addi    $1, $1, -1
sw      $1, 12($0)
addi    $1, $1, -1
sw      $1, 13($0)
addi    $1, $1, -1
sw      $1, 14($0)
addi    $1, $1, -1
sw      $1, 15($0)

