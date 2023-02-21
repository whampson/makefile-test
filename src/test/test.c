#include <mm.h>
#include <kernel.h>

int main(int argc, char **argv)
{
    mm_init();
    kmain();
    return 0;
}
