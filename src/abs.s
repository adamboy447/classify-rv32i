.globl abs

.text
# =================================================================
# FUNCTION: Absolute Value Converter
#
# Transforms any integer into its absolute (non-negative) value by
# modifying the original value through pointer dereferencing.
# For example: -5 becomes 5, while 3 remains 3.
#
# Args:
#   a0 (int *): Memory address of the integer to be converted
#
# Returns:
#   None - The operation modifies the value at the pointer address
# =================================================================
abs:
    # Prologue

    # Load number from memory
    lw t0, 0(a0)      # Load the integer from the address in a0 to t0
    bge t0, zero, done # If t0 >= 0, jump to done (already non-negative)

    # Negate the value to make it positive
    neg t0, t0        # t0 = -t0

    # Store the updated value back into memory
    sw t0, 0(a0)      # Store the new value back to the address in a0

done:
    # Epilogue
    jr ra             # Return to the caller
