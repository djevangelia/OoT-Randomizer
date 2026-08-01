.headersize (0x808137c0 - 0x00bb11e0)

; Prevent magicFillTarget from getting overwritten if dying
; during refill (game over respawn)
; Replaces: lb  t7,51(t1)
;           sh  zero,5156(t1)
;           sh  zero,5104(t1)
;           sh  zero,5106(t1)
.org 0x80828890         ; in KaleidoScope_Update
    jal     Kaleido_GameOverFillMagic
    lb      t7,51(t1)           ; displaced
    bnez    v0,0x808288a8       ; skip zero fill target
    sh      zero,5106(t1)

; Load custom item name panel
; Replaces: addu    a1,t4,t5
;           jal     DmaMgr_RequestSync
;           sw      v0,28(sp)
.org 0x80822e70     ; KaleidoScope_UpdateNamePanel
    move    a0,a3   ; play
    jal     KaleidoScope_LoadCustomName
    sw      v0,28(sp)

; Don't grey ITEM_SOLD_OUT menu item texture due to age (for Navi bell)
; Replaces: lui     v0,0x8083
;           addu    v0,v0,v1
;           lbu     v0,-25188(v0)
.org 0x80826608     ; KaleidoScope_Update
    lui     v0,0x8083
    jal     KaleidoScope_CheckAgeReqItemScreen
    addiu   v0,v0,-25188            ; gItemAgeReqs
