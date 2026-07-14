MEMORY {
   BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x4000  /* 6kB RAM */
}
SECTIONS
{
    everything :
    {
        . = ALIGN(4);
        call_test.o get_number.o bin2bcd.o bcd2bin.o bin_to_bcd.o putchar.o getchar.o putstring.o(.text)
        *(.*)
    } >BRAM
}
