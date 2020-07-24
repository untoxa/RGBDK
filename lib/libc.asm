
SECTION "Libc", ROM0

_printf::
	ret

banked_call::            ; Performs a long call.
    pop    hl        ; Get the return address
    ldh    a,[hCurROMBank]
    push    af        ; Push the current bank onto the stack
    ld    a,[hl+]        ; Fetch the call address
    ld    e, a
    ld    a,[hl+]
    ld    d, a
    ld    a,[hl+]        ; ...and page
    inc    hl        ; Yes this should be here
    push    hl        ; Push the real return address
    ldh    [hCurROMBank],a
    ld    [$2000],a    ; Perform the switch
    ld    l,e
    ld    h,d
    call jump
    pop    hl        ; Get the return address
    pop    af        ; Pop the old bank
    ld    [$2000],a ; rROMB0
    ldh    [hCurROMBank],a
jump:
    jp    hl

banked_call_ehl::   ; Performs a long call.
    ldh   a,[hCurROMBank]
    push   af  ; Push the current bank onto the stack
    ld    a, e
    ldh    [hCurROMBank],a
    ld    [$2000],a ; Perform the switch
    call jump
    pop af  ; Pop the old bank
    ld    [$2000],a
    ldh    [hCurROMBank],a
    ret
