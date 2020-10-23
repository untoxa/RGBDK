/** @file asm/types.h
    Shared types definitions.
*/
#ifndef ASM_TYPES_INCLUDE
#define ASM_TYPES_INCLUDE

#define NONBANKED __nonbanked
#define BANKED __banked

/** Signed eight bit.
 */
typedef signed char     INT8;
/** Unsigned eight bit.
 */
typedef unsigned char 	UINT8;
/** Signed sixteen bit.
 */
typedef signed int      INT16;
/** Unsigned sixteen bit.
 */
typedef unsigned int  	UINT16;
/** Signed 32 bit.
 */
typedef signed long     INT32;
/** Unsigned 32 bit.
 */
typedef unsigned long 	UINT32;

typedef int	      	size_t;

/** Returned from clock
    @see clock
*/
typedef UINT16		clock_t;

/** TRUE or FALSE.
 */
typedef INT8		BOOLEAN;

#if BYTE_IS_UNSIGNED

typedef UINT8		BYTE;
typedef UINT16		WORD;
typedef UINT32		DWORD;

#else

/** Signed 8 bit.
 */
typedef INT8         	BYTE;
/** Unsigned 8 bit.
 */
typedef UINT8        	UBYTE;
/** Signed 16 bit */
typedef INT16      	WORD;
/** Unsigned 16 bit */
typedef UINT16       	UWORD;
/** Signed 32 bit */
typedef INT32       	LWORD;
/** Unsigned 32 bit */
typedef UINT32      	ULWORD;
/** Signed 32 bit */
typedef INT32	   	DWORD;
/** Unsigned 32 bit */
typedef UINT32	   	UDWORD;

/** Useful definition for fixed point values */
typedef union _fixed {
  struct {
    UBYTE l;
    UBYTE h;
  } b;
  UWORD w;
} fixed;

#endif

#endif
