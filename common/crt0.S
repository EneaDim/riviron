.section .text
.global _mystart

_mystart:
    /* Set up the stack pointer */
    la sp, _stack_top  /* Load the stack pointer with the top of the stack */

    /* Initialize the .data section */
    la a0, _data_start  /* Load address of the start of .data */
    la a1, _data_end    /* Load address of the end of .data */
    
    /* Copy initialized data from ROM to RAM */
    beq a0, a1, call_main  /* If .data is empty, skip copying */
copy_data:
    lw t0, 0(a0)        /* Load word from ROM */
    sw t0, 0(a1)        /* Store word to RAM */
    addi a0, a0, 4      /* Move to the next word in .data */
    addi a1, a1, 4      /* Move to the next word in .data */
    
    /* Compare current address with _data_end */
    bne a0, a1, copy_data  /* Repeat until done */

call_main:
    /* Call the main function */
    call main           /* Call the main function */

    /* Exit the program */
    li a0, 0            /* Load exit code (0 for success) */
    li a7, 10           /* Load the exit syscall number */
    ecall               /* Make the syscall to exit */

.section .bss
.data
_data_start:
    .space 0x100        /* Reserve space for initialized data */
_data_end:

.section .stack
.stack_top:
    .space 0x1000       /* Reserve 4KB for the stack */
