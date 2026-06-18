ObjLightswitch_CheckTrigger:
    bnel    v0,at,@@Return  ; if not fire, continue
    nop

    la      t6,gLightOn     ; player press light trigger?
    lb      t7,(t6)
    beqzl   t7,@@Return     ; if not, continue as regular fire 
    addi    ra,0x74
    
    addi    ra,0x80         ; if yes, fire sun, and reset light trigger
    sb      zero,(t6)
@@Return:
    jr      ra
    lw      ra,20(sp)

ObjSyokudai_CallDrawCylinder:
    addiu   sp,sp,-24
    sdc1    $f20,56(sp)
    sw      ra,16(sp)
    move    a0,s2           ; play
    lh      t4,180(s1)      ; actor shaperot x
    bnez    t4,@@DrawRB
    nop
    lh      t4,184(s1)      ; actor shaperot z
    bnez    t4,@@DrawRB
    nop
    ;jal     Collider_DrawCylinderBW    ; draw non-tilted collider
    ;addi    a1,s1,392       ; ObjSyokudai->flameCollider
    b       @@Return
    lw      ra,16(sp)
@@DrawRB:
    jal     Collider_DrawCylinderRB
    addi    a1,s1,392       ; ObjSyokudai->flameCollider
    lw      ra,16(sp)
@@Return:
    jr      ra
    addiu   sp,sp,24

EnKz_DebugTalk:
    lw      t0,7236(s1)     ; player address
    lwc1    $f0,36(t0)      ; pos x
    lui     at,0x42c8
    mtc1    at,$f2          ; 100.0f
    add.s   $f0,$f0,$f2
    swc1    $f0,36(t0)      ; new pos x + 100.0f
    li      t7,1
    jr      ra
    li      v0,1
