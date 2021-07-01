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

/** Sprite attribute structure
    x x-coord of the sprite on screen
    y y-coord of the sprite on screen
    tile sprite tile number
    prop sprite properties
*/

typedef struct OAM_item_t {
    UINT8 y, x;
    UINT8 tile;
    UINT8 prop;
} OAM_item_t;

/** Shadow OAM array in WRAM, that is DMA-transferred into the real OAM each VBlank
*/

extern volatile struct OAM_item_t shadow_OAM[];

/** Sets sprite n to display tile number t, from the sprite tile data. 
    If the GB is in 8x16 sprite mode then it will display the next
    tile, t+1, below the first tile.
    @param nb		Sprite number, range 0 - 39
*/

inline void set_sprite_tile(UINT8 nb, UINT8 tile) {
    shadow_OAM[nb].tile=tile; 
}

inline UINT8 get_sprite_tile(UINT8 nb) {
    return shadow_OAM[nb].tile;
}

/** Sets the property of sprite n to those defined in p.
    Where the bits in p represent:
    Bit 7 - 	Priority flag. When this is set the sprites appear behind the
		background and window layer. 0: infront, 1: behind.
    Bit 6 - 	Vertical flip. Dictates which way up the sprite is drawn
		vertically. 0: normal, 1:upside down.
    Bit 5 - 	Horizontal flip. Dictates which way up the sprite is
    drawn horizontally. 0: normal, 1:back to front.
    Bit 4 - 	DMG only. Assigns either one of the two b/w palettes to the sprite.
		0: OBJ palette 0, 1: OBJ palette 1.
    Bit 3 -	GBC only. Dictates from which bank of Sprite Tile Patterns the tile
		is taken. 0: Bank 0, 1: Bank 1
    Bit 2 -	See bit 0.
    Bit 1 -	See bit 0. 
    Bit 0 - 	GBC only. Bits 0-2 indicate which of the 7 OBJ colour palettes the
		sprite is assigned.
    
    @param nb		Sprite number, range 0 - 39
*/

inline void set_sprite_prop(UINT8 nb, UINT8 prop){
    shadow_OAM[nb].prop=prop;
}

inline UINT8 get_sprite_prop(UINT8 nb){
    return shadow_OAM[nb].prop;
}

/** Moves the given sprite to the given position on the
    screen.
    Dont forget that the top left visible pixel on the screen
    is at (8,16).  To put sprite 0 at the top left, use
    move_sprite(0, 8, 16);
*/
inline void move_sprite(UINT8 nb, UINT8 x, UINT8 y) {
    OAM_item_t * itm = &shadow_OAM[nb];
    itm->y=y, itm->x=x; 
}

/** Moves the given sprite relative to its current position.
 */
inline void scroll_sprite(UINT8 nb, INT8 x, INT8 y) {
    OAM_item_t * itm = &shadow_OAM[nb];
    itm->y+=y, itm->x+=x; 
}

#endif