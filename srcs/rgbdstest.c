#include <gb/gb.h>
#include <stdio.h>
#include <string.h>

#include "rgbdstest.b1.h"

extern volatile UINT8 shadow_LCDC;
extern volatile UINT8 shadow_SCY;
extern volatile UINT8 shadow_SCX;
extern volatile UINT8 shadow_BGP;
extern volatile UINT8 shadow_OBP0;
extern volatile UINT8 shadow_OBP1;

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
