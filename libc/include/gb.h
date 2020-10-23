#ifndef GB_H_INCLUDE
#define GB_H_INCLUDE

#include <types.h>

extern volatile UINT8 shadow_LCDC;
extern volatile UINT8 shadow_SCY;
extern volatile UINT8 shadow_SCX;
extern volatile UINT8 shadow_BGP;
extern volatile UINT8 shadow_OBP0;
extern volatile UINT8 shadow_OBP1;

extern volatile UINT8 JoypadHeld;
extern volatile UINT8 JoypadPressed;

#endif