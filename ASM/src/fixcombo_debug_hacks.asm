.headersize (0x809087d0 - 0x00ca5f80)
; Debug, draw the flameCollider
; Replaces: sw      s0,64(sp)
;           sdc1    $f20,56(sp)
.org 0x8090901c             ; in ObjSyokudai_Draw
    jal     ObjSyokudai_CallDrawCylinder
    sw      s0,64(sp)       ; displaced

.headersize (0x80abc320 - 0x00e3c170)
; Check if player pressed trigger, to activate fire sun switch
; Replaces  beql    v0,at,80abc9cc <ObjLightswitch_Off+0xb0>
;           lbu     t2,337(a0)   
.org 0x80abc950
    jal     ObjLightswitch_CheckTrigger
    nop

.headersize(0x80AD5D60 - 0x00E55BA0)
; KZ debug talk displacement
.org 0x80ad6178     ; in EnKz_UpdateTalking
     jal     EnKz_DebugTalk
     nop