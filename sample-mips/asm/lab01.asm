# Initialize the values of a and b
li   $1, 4         # Load immediate value 4 into register $1 (a)
li   $2, 6         # Load immediate value 6 into register $2 (b)

# Swap the values of a and b using t as temporary
move $3, $1        # Move value of $1 (a) to $3 (t)
move $1, $2        # Move value of $2 (b) to $1 (a)
move $2, $3        # Move value of $3 (t) to $2 (b)