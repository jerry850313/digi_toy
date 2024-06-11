li $0, 100
li $2, 1
li $3, 0

loop: 
add $3, $3, $2
addi $2, $2, 1
ble $2, $0, loop

