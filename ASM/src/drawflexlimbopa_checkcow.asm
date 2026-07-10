DrawFlexLimbOpa_CheckCow:
    lw      a2,68(sp)       ; play
    lw      v1,704(a2)      ; poly_opa_disp
    lw      t4,108(sp)      ; limbIndex
    li      at,5            ; COW_LIMB_NOSE_RING
    bne     at,t4,@@Return  ; if not right limb index, return
    nop

    lw      a1,20(sp)       ; void* this
    lh      t4,(a1)         ; actor id
    li      t5,0x1c6        ; En_Cow
    bne     t4,t5,@@Return  ; if not cow, return
    nop

    lw      t4,96(sp)       ; dList
    beqz    t4,@@Return     ; if dList is null, return
    nop

    addiu   sp,sp,-24
    sw      ra,16(sp)
    sw      a2,20(sp)

    move    a2,t4           ; dList (might not be needed)
    jal     EnCow_ColorNoseRing
    lw      a0,128(sp)      ; 104+24, play

    lw      ra,16(sp)
    lw      a2,20(sp)
    move    v1,v0           ; return = new poly_opa_disp
    addiu   sp,sp,24

@@Return:
    jr      ra
    nop
