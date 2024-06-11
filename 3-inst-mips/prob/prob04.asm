li $1, 0         # s = 0
li $2, 1         # i = 1
li $3, 20        # limit = 20
li $4, 2         # step = 2

loop:
bge $2, $3, end  # if i >= 20, jump to end
add $1, $1, $2   # s += i
add $2, $2, $4   # i += 2
j loop           # jump back to loop
end:
