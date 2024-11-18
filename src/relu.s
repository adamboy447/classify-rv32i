.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================

relu:
    # Validate input length
    li t0, 1
    blt a1, t0, error       # If length < 1, exit with error

    # Prologue

    mv t5, a0               # Base pointer of the array
    li t1, 0                # Loop index

relu_loop:
    bge t1, a1, relu_done   # If index >= length, exit loop

    slli t3, t1, 2          # Offset = index * 4
    add t4, t5, t3          # Address of element
    lw t2, 0(t4)            # Load element

    blt t2, zero, relu_zero
    j relu_store

relu_zero:
    li t2, 0                # If element < 0, set to 0

relu_store:
    sw t2, 0(t4)            # Store updated value
    addi t1, t1, 1          # Increment index
    j relu_loop

relu_done:
    # Epilogue
    jr ra

error:
    li a0, 36
    j exit
