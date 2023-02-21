#include <stdio.h>
#include <drivers/kbd.h>
#include <drivers/vga.h>
#include <mm.h>

#include "init.h"

int main(int argc, char **argv)
{
    printf("main()\n");
    init_func1();
    init_func2();
    init_func3();

    mm_init();
    vga_init();
    kbd_init();

    return 0;
}
