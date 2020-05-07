	; Automagically from "crt0.s" by 
	INCLUDE "global.asm"
	
	;  ****************************************
	;  Beginning of module
	;  BANKED: checked
	; Dropping .title "Runtime"
	SECTION "Runtime_1",ROM0
	
	;  Standard header for the GB
	SECTION "Runtime_2",ROM0[$00]
	RET		;  Empty function (default for interrupts)
	
	SECTION "Runtime_3",ROM0[$08]
___sdcc_call_hl:			
	JP	HL	
	
	SECTION "Runtime_4",ROM0[$10]
	DB	$80,$40,$20,$10,$08,$04,$02,$01	
	DB	$01,$02,$04,$08,$10,$20,$40,$80	
	
	;  Interrupt vectors
	SECTION "Runtime_5",ROM0[$40]
int_VBL:			
	PUSH	HL	
	LD	HL,int_0x40	
	JP	int	
	
	SECTION "Runtime_6",ROM0[$48]
int_LCD:			
	PUSH	HL	
	LD	HL,int_0x48	
	JP	int	
	
	SECTION "Runtime_7",ROM0[$50]
int_TIM:			
	PUSH	HL	
	LD	HL,int_0x50	
	JP	int	
	
	SECTION "Runtime_8",ROM0[$58]
int_SIO:			
	PUSH	HL	
	LD	HL,int_0x58	
	JP	int	
	
	SECTION "Runtime_9",ROM0[$60]
int_JOY:			
	PUSH	HL	
	LD	HL,int_0x60	
	JP	int	
	
int:			
	PUSH	AF	
	PUSH	BC	
	PUSH	DE	
.l1:			
	LD	A,[HL+]	
	OR	[HL]	
	JR	Z,.l2	
	PUSH	HL	
	LD	A,[HL-]	
	LD	L,[HL]	
	LD	H,A	
	CALL	.l3	
	POP	HL	
	INC	HL	
	JR	.l1	
.l2:			
	POP	DE	
	POP	BC	
	POP	AF	
	POP	HL	
	RETI		
	
.l3:			
	JP	HL	
	
	;  GameBoy Header
	
	;  DO NOT CHANGE...
	SECTION "Runtime_10",ROM0[$100]
header:			
	NOP		
	JP	$150	
	DB	$CE,$ED,$66,$66	
	DB	$CC,$0D,$00,$0B	
	DB	$03,$73,$00,$83	
	DB	$00,$0C,$00,$0D	
	DB	$00,$08,$11,$1F	
	DB	$88,$89,$00,$0E	
	DB	$DC,$CC,$6E,$E6	
	DB	$DD,$DD,$D9,$99	
	DB	$BB,$BB,$67,$63	
	DB	$6E,$0E,$EC,$CC	
	DB	$DD,$DC,$99,$9F	
	DB	$BB,$B9,$33,$3E	
	
	;  Title of the game
	SECTION "Runtime_11",ROM0[$134]
	DB	"Title",0
	
	SECTION "Runtime_12",ROM0[$144]
	DB	0,0,0	
	
	;  Cartridge type is ROM only
	SECTION "Runtime_13",ROM0[$147]
	DB	0	
	
	;  ROM size is 32kB
	SECTION "Runtime_14",ROM0[$148]
	DB	0	
	
	;  RAM size is 0kB
	SECTION "Runtime_15",ROM0[$149]
	DB	0	
	
	;  Maker ID
	SECTION "Runtime_16",ROM0[$14A]
	DB	$00,$00	
	
	;  Version number
	SECTION "Runtime_17",ROM0[$14C]
	DB	$01	
	
	;  Complement check
	SECTION "Runtime_18",ROM0[$14D]
	DB	$00	
	
	;  Checksum
	SECTION "Runtime_19",ROM0[$14E]
	DB	$00,$00	
	
	;  ****************************************
	SECTION "Runtime_20",ROM0[$150]
code_start:			
	;  Beginning of the code
	DI		;  Disable interrupts
	LD	D,A	;  Store CPU type in D
	XOR	A	
	;  Initialize the stack
	LD	SP,STACK_ADDRESS	
	;  Clear from 0xC000 to 0xDFFF
	LD	HL,$DFFF	
	LD	C,$20	
	LD	B,$00	
.l1:			
	LD	[HL-],A	
	DEC	B	
	JR	NZ,.l1	
	DEC	C	
	JR	NZ,.l1	
	;  Clear from 0xFE00 to 0xFEFF
	LD	HL,$FEFF	
	LD	B,$00	
.l2:			
	LD	[HL-],A	
	DEC	B	
	JR	NZ,.l2	
	;  Clear from 0xFF80 to 0xFFFF
	LD	HL,$FFFF	
	LD	B,$80	
.l3:			
	LD	[HL-],A	
	DEC	B	
	JR	NZ,.l3	
	;  	LD	(.mode),A	
	;  Store CPU type
	LD	A,D	
	LD	[__cpu],A	
	
	;  Turn the screen off
	CALL	display_off	
	
	;  Initialize the display
	XOR	A	
	LD	[$FF00+SCY],A	
	LD	[$FF00+SCX],A	
	LD	[$FF00+STAT],A	
	LD	[$FF00+WY],A	
	LD	A,$07	
	LD	[$FF00+WX],A	
	
	;  Copy refresh_OAM routine to HIRAM
	LD	BC,refresh_OAM	
	LD	HL,start_refresh_OAM	
	LD	B,end_refresh_OAM-start_refresh_OAM	
.l4:			
	LD	A,[HL+]	
	LD	[C],A	
	INC	C	
	DEC	B	
	JR	NZ,.l4	
	
	;  Install interrupt routines
	LD	BC,vbl	
	CALL	add_VBL	
	LD	BC,serial_IO	
	CALL	add_SIO	
	
	;  Standard color palettes
	LD	A,%11100100	;  Grey 3 = 11 (Black)
	;  Grey 2 = 10 (Dark grey)
	;  Grey 1 = 01 (Light grey)
	;  Grey 0 = 00 (Transparent)
	LD	[$FF00+BGP],A	
	LD	[$FF00+OBP0],A	
	LD	A,%00011011	
	LD	[$FF00+OBP1],A	
	
	;  Turn the screen on
	LD	A,%11000000	;  LCD		= On
	;  WindowBank	= 0x9C00
	;  Window	= Off
	;  BG Chr	= 0x8800
	;  BG Bank	= 0x9800
	;  OBJ		= 8x8
	;  OBJ		= Off
	;  BG		= Off
	LD	[$FF00+LCDC],A	
	XOR	A	
	LD	[$FF00+R_IF],A	
	LD	A,%00001001	;  Pin P10-P13	=   Off
	;  Serial I/O	=   On
	;  Timer Ovfl	=   Off
	;  LCDC		=   Off
	;  V-Blank	=   On
	LD	[$FF00+IE],A	
	
	XOR	A	
	LD	[$FF00+NR52],A	;  Turn sound off
	LD	[$FF00+SC],A	;  Use external clock
	LD	A,DT_IDLE	
	LD	[$FF00+SB],A	;  Send IDLE byte
	LD	A,$80	
	LD	[$FF00+SC],A	;  Use external clock
	
	XOR	A	;  Erase the malloc list
	; 	LD	(_malloc_heap_start+0),A
	; 	LD	(_malloc_heap_start+1),A
	; 	LD	(.sys_time+0),A	
	; 	LD	(.sys_time+1),A	
	
	CALL	gsinit	
	
	; 	CALL	.init		
	
	EI		;  Enable interrupts
	
	;  Call the main function
	CALL	banked_call	
	DW	_main	
IF	__RGBDS__	
	DW	BANK(_main)	
ELSE		
	DW	0	
ENDC		
_exit::			
.l99:			
	HALT		
	JR	.l99	;  Wait forever
	
	SECTION "Runtime_21",ROM0[MODE_TABLE]
	;  Jump table for modes
	RET		
	
	;  ****************************************
	
	;  Ordering of segments for the linker
	;  Code that really needs to be in bank 0
	SECTION "Runtime_22",ROM0
	;  Similar to _HOME
	SECTION "Runtime_23",ROM0
	;  Code
	SECTION "Runtime_24",ROM0
	;  Constant data
	SECTION "Runtime_25",ROM0
	;  Constant data used to init _DATA
	SECTION "Runtime_26",ROM0
	SECTION "Runtime_27",ROM0
	SECTION "Runtime_28",ROM0
	;  Initialised in ram data
	SECTION "Runtime_29",WRAM0
	;  Uninitialised ram data
	SECTION "Runtime_30",WRAM0
	;  For malloc
	SECTION "Runtime_31",WRAM0
	
	SECTION "Runtime_32",WRAM0
__cpu::			
	DS	$01	;  GB type (GB, PGB, CGB)
mode::			
	DS	$01	;  Current mode
__io_out::			
	DS	$01	;  Byte to send
__io_in::			
	DS	$01	;  Received byte
__io_status::			
	DS	$01	;  Status of serial IO
vbl_done::			
	DS	$01	;  Is VBL interrupt finished?
__current_bank::			
	DS	$01	;  Current MBC1 style bank.
sys_time::			
_sys_time::			
	DS	$02	;  System time in VBL units
int_0x40::			
	DS	$08	
int_0x48::			
	DS	$08	
int_0x50::			
	DS	$08	
int_0x58::			
	DS	$08	
int_0x60::			
	DS	$08	

	SECTION "Runtime_37",HRAM
refresh_OAM::
	DS	10

	
	;  Runtime library
	SECTION "Runtime_33",ROM0
gsinit::			
	SECTION "Runtime_34",ROM0
	RET		
	
	SECTION "Runtime_35",ROM0
	;  Call the initialization function for the mode specified in HL
set_mode::			
	LD	A,L	
	LD	[mode],A	
	
	;  AND to get rid of the extra flags
	AND	$03	
	LD	L,A	
	LD	BC,MODE_TABLE	
	SLA	L	;  Multiply mode by 4
	SLA	L	
	ADD	HL,BC	
	JP	HL	;  Jump to initialization routine
	
	;  Add interrupt routine in BC to the interrupt list
remove_VBL::			
	LD	HL,int_0x40	
	JP	remove_int	
remove_LCD::			
	LD	HL,int_0x48	
	JP	remove_int	
remove_TIM::			
	LD	HL,int_0x50	
	JP	remove_int	
remove_SIO::			
	LD	HL,int_0x58	
	JP	remove_int	
remove_JOY::			
	LD	HL,int_0x60	
	JP	remove_int	
add_VBL::			
	LD	HL,int_0x40	
	JP	add_int	
add_LCD::			
	LD	HL,int_0x48	
	JP	add_int	
add_TIM::			
	LD	HL,int_0x50	
	JP	add_int	
add_SIO::			
	LD	HL,int_0x58	
	JP	add_int	
add_JOY::			
	LD	HL,int_0x60	
	JP	add_int	
	
	;  Remove interrupt BC from interrupt list HL if it exists
	;  Abort if a 0000 is found (end of list)
	;  Will only remove last int on list
remove_int::			
.l1:			
	LD	A,[HL+]	
	LD	E,A	
	LD	D,[HL]	
	OR	D	
	RET	Z	;  No interrupt found
	
	LD	A,E	
	CP	C	
	JR	NZ,.l1	
	LD	A,D	
	CP	B	
	JR	NZ,.l1	
	
	XOR	A	
	LD	[HL-],A	
	LD	[HL],A	
	
	;  Now do a memcpy from here until the end of the list
	LD	D,H	
	LD	E,L	
	INC	HL	
	INC	HL	
	
.l2:			
	LD	A,[HL+]	
	LD	[DE],A	
	LD	B,A	
	INC	DE	
	LD	A,[HL+]	
	LD	[DE],A	
	INC	DE	
	OR	B	
	RET	Z	
	JR	.l2	
	
	;  Add interrupt routine in BC to the interrupt list in HL
add_int::			
.l1:			
	LD	A,[HL+]	
	OR	[HL]	
	JR	Z,.l2	
	INC	HL	
	JR	.l1	
.l2:			
	LD	[HL],B	
	DEC	HL	
	LD	[HL],C	
	RET		
	
	
	;  VBlank interrupt
vbl:			
	LD	HL,sys_time	
	INC	[HL]	
	JR	NZ,.l2	
	INC	HL	
	INC	[HL]	
.l2:			
	CALL	refresh_OAM	
	
	LD	A,$01	
	LD	[vbl_done],A	
	RET		
	
	;  Wait for VBL interrupt to be finished
wait_vbl_done::			
_wait_vbl_done::			
	;  Check if the screen is on
	LD	A,[$FF00+LCDC]	
	ADD	A	
	RET	NC	;  Return if screen is off
	XOR	A	
	DI		
	LD	[vbl_done],A	;  Clear any previous sets of vbl_done
	EI		
.l1:			
	HALT		;  Wait for any interrupt
	NOP		;  HALT sometimes skips the next instruction
	LD	A,[vbl_done]	;  Was it a VBlank interrupt?
	;  Warning: we may lose a VBlank interrupt, if it occurs now
	OR	A	
	JR	Z,.l1	;  No: back to sleep!
	
	XOR	A	
	LD	[vbl_done],A	
	RET		
	
display_off::			
_display_off::			
	;  Check if the screen is on
	LD	A,[$FF00+LCDC]	
	ADD	A	
	RET	NC	;  Return if screen is off
.l1:			;  We wait for the *NEXT* VBL 
	LD	A,[$FF00+LY]	
	CP	$92	;  Smaller than or equal to 0x91?
	JR	NC,.l1	;  Loop until smaller than or equal to 0x91
.l2:			
	LD	A,[$FF00+LY]	
	CP	$91	;  Bigger than 0x90?
	JR	C,.l2	;  Loop until bigger than 0x90
	
	LD	A,[$FF00+LCDC]	
	AND	%01111111	
	LD	[$FF00+LCDC],A	;  Turn off screen
	RET		
	
	;  Copy OAM data to OAM RAM
start_refresh_OAM:			
	LD	A,(OAM_ADDRESS>>8)	
	LD	[$FF00+DMA],A	;  Put A into DMA registers
	LD	A,$28	;  We need to wait 160 ns
.l1:			
	DEC	A	
	JR	NZ,.l1	
	RET		
end_refresh_OAM:			
	
	;  Serial interrupt
serial_IO::			
	LD	A,[__io_status]	;  Get status
	
	CP	IO_RECEIVING	
	JR	NZ,.l10	
	
	;  Receiving data
	LD	A,[$FF00+SB]	;  Get data byte
	LD	[__io_in],A	;  Store it
	LD	A,IO_IDLE	
	JR	.l11	
	
.l10:			
	
	CP	IO_SENDING	
	JR	NZ,.l99	
	
	;  Sending data
	LD	A,[$FF00+SB]	;  Get data byte
	CP	DT_RECEIVING	
	JR	Z,.l11	
	LD	A,IO_ERROR	
	JR	.l12	
.l11:			
	LD	A,IO_IDLE	
.l12:			
	LD	[__io_status],A	;  Store status
	
	XOR	A	
	LD	[$FF00+SC],A	;  Use external clock
	LD	A,DT_IDLE	
	LD	[$FF00+SB],A	;  Reply with IDLE byte
.l99:			
	LD	A,$80	
	LD	[$FF00+SC],A	;  Enable transfer with external clock
	RET		
	
_mode::			
	LD	HL,SP+2		;  Skip return address
	LD	L,[HL]	
	LD	H,$00	
	CALL	set_mode	
	RET		
	
_get_mode::			
	LD	HL,mode	
	LD	E,[HL]	
	RET		
	
_enable_interrupts::			
	EI		
	RET		
	
_disable_interrupts::			
	DI		
	RET		
	
reset::			
_reset::			
	LD	A,[__cpu]	
	JP	code_start	
	
_set_interrupts::			
	DI		
	LD	HL,SP+2		;  Skip return address
	XOR	A	
	LD	[$FF00+R_IF],A	;  Clear pending interrupts
	LD	A,[HL]	
	LD	[$FF00+IE],A	
	EI		;  Enable interrupts
	RET		
	
_remove_VBL::			
	PUSH	BC	
	LD	HL,SP+4		;  Skip return address and registers
	LD	C,[HL]	
	INC	HL	
	LD	B,[HL]	
	CALL	remove_VBL	
	POP	BC	
	RET		
	
_remove_LCD::			
	PUSH	BC	
	LD	HL,SP+4		;  Skip return address and registers
	LD	C,[HL]	
	INC	HL	
	LD	B,[HL]	
	CALL	remove_LCD	
	POP	BC	
	RET		
	
_remove_TIM::			
	PUSH	BC	
	LD	HL,SP+4		;  Skip return address and registers
	LD	C,[HL]	
	INC	HL	
	LD	B,[HL]	
	CALL	remove_TIM	
	POP	BC	
	RET		
	
_remove_SIO::			
	PUSH	BC	
	LD	HL,SP+4		;  Skip return address and registers
	LD	C,[HL]	
	INC	HL	
	LD	B,[HL]	
	CALL	remove_SIO	
	POP	BC	
	RET		
	
_remove_JOY::			
	PUSH	BC	
	LD	HL,SP+4		;  Skip return address and registers
	LD	C,[HL]	
	INC	HL	
	LD	B,[HL]	
	CALL	remove_JOY	
	POP	BC	
	RET		
	
_add_VBL::			
	PUSH	BC	
	LD	HL,SP+4		;  Skip return address and registers
	LD	C,[HL]	
	INC	HL	
	LD	B,[HL]	
	CALL	add_VBL	
	POP	BC	
	RET		
	
_add_LCD::			
	PUSH	BC	
	LD	HL,SP+4		;  Skip return address and registers
	LD	C,[HL]	
	INC	HL	
	LD	B,[HL]	
	CALL	add_LCD	
	POP	BC	
	RET		
	
_add_TIM::			
	PUSH	BC	
	LD	HL,SP+4		;  Skip return address and registers
	LD	C,[HL]	
	INC	HL	
	LD	B,[HL]	
	CALL	add_TIM	
	POP	BC	
	RET		
	
_add_SIO::			
	PUSH	BC	
	LD	HL,SP+4		;  Skip return address and registers
	LD	C,[HL]	
	INC	HL	
	LD	B,[HL]	
	CALL	add_SIO	
	POP	BC	
	RET		
	
_add_JOY::			
	PUSH	BC	
	LD	HL,SP+4		;  Skip return address and registers
	LD	C,[HL]	
	INC	HL	
	LD	B,[HL]	
	CALL	add_JOY	
	POP	BC	
	RET		
	
_clock::			
	LD	hl,sys_time	
	DI		
	LD	a,[hl+]	
	EI		
	;  Interrupts are disabled for the next instruction...
	LD	d,[hl]	
	LD	e,a	
	RET		
	
__printTStates::			
	RET		
	
	;  Performs a long call.
	;  Basically:
	;    call banked_call
	;    .dw low
	;    .dw bank
	;    remainder of the code
	;  Total m-cycles:
	; 	3+4+4 + 2+2+2+2+2+2 + 4+4+ 3+4+1+1+1
	;       = 41 for the call
	; 	3+3+4+4+1
	; 	= 15 for the ret
banked_call::			
	POP	hl	;  Get the return address
	LD	a,[__current_bank]	
	PUSH	af	;  Push the current bank onto the stack
	LD	e,[hl]	;  Fetch the call address
	INC	hl	
	LD	d,[hl]	
	INC	hl	
	LD	a,[hl+]	;  ...and page
	INC	hl	;  Yes this should be here
	PUSH	hl	;  Push the real return address
	LD	[__current_bank],a	
	LD	[MBC1_ROM_PAGE],a	;  Perform the switch
	LD	hl,banked_ret	;  Push the fake return address
	PUSH	hl	
	LD	l,e	
	LD	h,d	
	JP	hl	
	
banked_ret::			
	POP	hl	;  Get the return address
	POP	af	;  Pop the old bank
	LD	[MBC1_ROM_PAGE],a	
	LD	[__current_bank],a	
	JP	hl	
	
	SECTION "Runtime_36",WRAM0
_malloc_heap_start::			
