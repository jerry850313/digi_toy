li $1, 33           # a = 33
li $2, 11           # b = 11        
li $3, 22           # c = 22         

ble $1, $2, label1  # If a <= b, jump to label1
move $4, $1         # temp = a
move $1, $2         # a = b
move $2, $4         # b = temp
label1:

ble $2, $3, label2  # If b <= c, jump to label2
move $4, $2         # temp = b
move $2, $3         # b = c
move $3, $4         # c = temp
label2:

ble $1, $2, label3  # If a <= b, jump to label3
move $4, $1         # temp = a
move $1, $2         # a = b
move $2, $4         # b = temp
label3:
