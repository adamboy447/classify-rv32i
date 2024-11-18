.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Arguments:
#   a0 (int*) - pointer to first array
#   a1 (int*) - pointer to second array
#   a2 (int)  - number of elements
#   a3 (int)  - stride of first array
#   a4 (int)  - stride of second array
# 
# Returns:
#   a0 (int)  - dot product result
# =======================================================

dot:
    # Prologue
    addi sp, sp, -40
    sw ra, 36(sp)
    sw s0, 32(sp)
    sw s1, 28(sp)
    sw s2, 24(sp)
    sw s3, 20(sp)
    sw s4, 16(sp)
    sw s5, 12(sp)
    sw s6, 8(sp)
    sw s7, 4(sp)
    sw s8, 0(sp)

    # Input validation
    li t0, 1
    blt a2, t0, invalid_count
    blt a3, t0, invalid_stride
    blt a4, t0, invalid_stride

    # Initialize
    li s0, 0                    # sum
    li s1, 0                    # counter
    mv s2, a0                   # array1 ptr
    mv s3, a1                   # array2 ptr
    slli s4, a3, 2             # stride1 bytes
    slli s5, a4, 2             # stride2 bytes
    mv s6, a2                   # element count

loop:
    bge s1, s6, done           # check loop end

    # Load values
    lw t1, 0(s2)               # load arr1 element
    lw t2, 0(s3)               # load arr2 element

    # multiplication
    li t3, 0                   # product
    mv t4, t1                  # multiplicand
    mv t5, t2                  # multiplier
    li t6, 0                   # sign flag

    # Handle signs
    bgez t4, check_t5
    sub t4, zero, t4
    xori t6, t6, 1

check_t5:
    bgez t5, mult_loop
    sub t5, zero, t5
    xori t6, t6, 1

mult_loop:
    andi t0, t5, 1             # check LSB
    beq t0, zero, shift_nums
    add t3, t3, t4             # add partial product

shift_nums:
    slli t4, t4, 1             # shift left multiplicand
    srli t5, t5, 1             # shift right multiplier
    bne t5, zero, mult_loop    # continue if multiplier != 0

    # Handle product sign
    beq t6, zero, accumulate
    sub t3, zero, t3           # negate if needed

accumulate:
    add s0, s0, t3             # add to total

    # Update pointers and counter
    add s2, s2, s4             # next arr1 element
    add s3, s3, s5             # next arr2 element
    addi s1, s1, 1             # increment counter
    j loop

done:
    mv a0, s0                  # store result

    # Epilogue
    lw ra, 36(sp)
    lw s0, 32(sp)
    lw s1, 28(sp)
    lw s2, 24(sp)
    lw s3, 20(sp)
    lw s4, 16(sp)
    lw s5, 12(sp)
    lw s6, 8(sp)
    lw s7, 4(sp)
    lw s8, 0(sp)
    addi sp, sp, 40
    jr ra

invalid_count:
    li a0, 36
    j exit

invalid_stride:
    li a0, 37
    j exit

exit:
    li a7, 93                  # exit syscall
    ecall
