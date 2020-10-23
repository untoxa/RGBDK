#include <gb.h>
#include <stdio.h>

#include "rgbdstest.b1.h"

int myint = 2;

int addint(int a, int b) {
    if (!a)
        return a + b;
    else
        return a - b;
}

void main() {
    shadow_LCDC = 0xd1u;

    shadow_BGP = shadow_OBP0 = shadow_OBP1 = 0xE4U;

    myint = addint(myint, 2);
    printf("res: %d\n", some_bank1_proc(1, 2, myint));

}
