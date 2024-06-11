<<<<<<< HEAD
# digi_toy
=======
### **Implement** Simplified ISA

### Complete Encoding Template

```assembly
# Load/Store Instructions
li   $rt, immediate       # 001001 00000 rt immediate           ----
lw   $rt, offset($rs)     # 100011 rs rt offset
sw   $rt, offset($rs)     # 101011 rs rt offset

# Arithmetic and Logical Instructions
add  $rd, $rs, $rt        # 000000 rs rt rd 00000 100000        ----
addi $rt, $rs, immediate  # 001000 rs rt immediate              ----
sub  $rd, $rs, $rt        # 000000 rs rt rd 00000 100010        ----
sll  $rd, $rt, shamt      # 000000 00000 rt rd shamt 000000     ----
srl  $rd, $rt, shamt      # 000000 00000 rt rd shamt 000010     ----
move $rd, $rs             # 000000 rs 00000 rd 00000 100001     ----

# Branch and Jump Instructions
bge  $rs, $rt, label      # 000111 rs rt label
ble  $rs, $rt, label      # 000110 rs rt label
j    label                # 000010 address
```
>>>>>>> c70d332 (Initial commit)
