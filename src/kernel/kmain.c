#include <stdio.h>
#include <kernel.h>
#include <mm.h>
#include "init.h"

void kmain()
{
    printf("kmain()\n");
    init_func1();
    init_func2();
    init_func3();
    mm_init();
}
