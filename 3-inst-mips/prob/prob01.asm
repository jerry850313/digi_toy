li $0, 10
li $1, 1
li $2, 1
li $3, 0

loop: 
add $3, $3, $2
add $2, $2, $1
ble $2, $0, loop

