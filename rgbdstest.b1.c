//#pragma bank 1

#include <stdio.h>

int res = 2;

const unsigned char const hello1[] = "bank1";

int some_nonbanked_proc(int a) __nonbanked {
    return a << 3;
}

int some_bank1_proc(int a, int b, int c) __banked {
    printf("  in %s\n", hello1);
    res = a + some_nonbanked_proc(b) + c;
    return res;
}