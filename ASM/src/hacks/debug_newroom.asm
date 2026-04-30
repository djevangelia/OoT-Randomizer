.headersize (0x80114dd0 - 0x00b8ad30)

; Debug, zero the ice trap room counter when switching room
; Replaces  move    a3,a2
;           lb      t6,49(s0)
.org 0x80080a50     ; in Room_RequestNewRoom
    jal     NewRoomRemoveIce
    move    a3,a2
