OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    ROM (rx) : ORIGIN = 0x00000000, LENGTH = 256K
    RAM (!rx) : ORIGIN = (ORIGIN(ROM) + LENGTH(ROM)), LENGTH = 768K
}

/* Define sections */
SECTIONS
{
    . = ORIGIN(ROM);   /* Start at the beginning of ROM */
    .text : {
        *(.text)       /* Include all .text sections from object files */
    } > ROM

    .data : {
        _data_start = .;  /* Mark the start of the .data section */
        *(.data)          /* Include all .data sections from object files */
        _data_end = .;    /* Mark the end of the .data section */
    } > RAM

    .bss : {
        __bss_start = .;  /* Mark the start of the BSS section */
        *(.bss)           /* Include all .bss sections from object files */
        _end = .;         /* Mark the end of the BSS section */
    } > RAM

    __global_pointer$ = ORIGIN(RAM) + 0x8000;  /* Define the global pointer */

    .stack (NOLOAD) : {
        . = ALIGN(4);             /* Align to a 4-byte boundary */
        _stack_top = . + 0x1000;  /* Reserve 4KB for the stack */
    } > RAM
}
