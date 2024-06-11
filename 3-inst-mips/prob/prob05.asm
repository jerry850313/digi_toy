li      $0, 0
li      $1, 1
li      $2, 77
li      $3, 88
li      $8, 0

loop:
ble     $3, $0, exit
add     $8, $8, $2
sub     $3, $3, $1
j       loop
exit:

