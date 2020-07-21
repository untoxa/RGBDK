#include <gb/gb.h>
#include <stdio.h>
#include <string.h>

#include "rgbdstest.b1.h"

int myint = 2;

int addint(int a, int b) {
  return a + b;
}

void main() {
    myint = addint(myint, 2);
    printf("res: %d\n", some_bank1_proc(1, 2, myint));

}
