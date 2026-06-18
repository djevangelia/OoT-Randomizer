.headersize (0x80abc320 - 0x00e3c170)

; Check if player pressed L, to activate fire sun switch
; Replaces  beql    v0,at,80abc9cc <ObjLightswitch_Off+0xb0>
;           lbu     t2,337(a0)   
.org 0x80abc950
    jal ObjLightswitch_CheckTrigger
    nop
