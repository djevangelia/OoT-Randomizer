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
