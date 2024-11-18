.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    # Validate array length
    li t6, 1
    blt a1, t6, error

    # Initialize max value and index
    lw t0, 0(a0)           # First element as max value
    li t1, 0               # Max index
    li t2, 1               # Loop counter

argmax_loop_start:
    beq t2, a1, argmax_done  # If end of array, exit loop

    slli t3, t2, 2          # Offset for current element
    add t4, a0, t3          # Address of element
    lw t5, 0(t4)            # Load element

    blt t5, t0, argmax_skip # Skip update if not greater
    mv t0, t5               # Update max value
    mv t1, t2               # Update max index

argmax_skip:
    addi t2, t2, 1          # Increment loop counter
    j argmax_loop_start

argmax_done:
    mv a0, t1               # Return index
    jr ra

error:
    li a0, 36
    j exit
