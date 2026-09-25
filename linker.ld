ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x40000000, LENGTH = 512M
}

SECTIONS
{
    . = ORIGIN(RAM);

    .text : ALIGN(4)
    {
        KEEP(*(.text.boot))
        *(.text .text.*)
    } > RAM

    .rodata : ALIGN(4)
    {
        *(.rodata .rodata.*)
    } > RAM

    .data : ALIGN(4)
    {
        *(.data .data.*)
    } > RAM

    __bss_start = .;
    .bss (NOLOAD) : ALIGN(4)
    {
        *(.bss .bss.*)
        *(COMMON)
    } > RAM
    __bss_end = .;

    . = ALIGN(16);
    __stack_top = ORIGIN(RAM) + LENGTH(RAM);

    /DISCARD/ :
    {
        *(.comment)
        *(.note*)
        *(.eh_frame*)
    }
}
