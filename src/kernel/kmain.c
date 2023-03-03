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

#ifdef MAIN
int main(int argc, char **argv)
{
    kmain();
    return 0;
}
#endif
