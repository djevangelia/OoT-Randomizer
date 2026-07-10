.headersize (0x80114dd0 - 0x00b8ad30)

; Check if cow ring and if it should be colored (ring matches contents)
; Replaces: sw      t7,4(v1)
;           lw      v1,704(a2)
.org 0x80089c5c ; in SkelAnime_DrawFlexLimbOpa
    jal     DrawFlexLimbOpa_CheckCow
    nop
