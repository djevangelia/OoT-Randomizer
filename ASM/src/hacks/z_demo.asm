.headersize (0x800110a0 - 0xa87000)

; Don't set "Bongo escaped well" flag and CS index when entering Kakariko
; (prevent Nocturne cutscene)
; jal     0x800288e0    ; set flag
; li      a0,170
; li      t7,0xfff0
; b       0x80056f84 
; sw      t7,8(s0)      ; set CS index
.org 0x80056e5c         ; in Cutscene_HandleConditionalTriggers
    nop
    nop
    nop
.skip 4
    nop
