
.headersize (0x80b56910 - 0x00ed2040)

; Goron overlay (including Link Goron, Biggoron)

;================================================================================
; Biggoron: Set EnGo2->reverse variable when turning in Claim Check/receiving BGS
; to delay changing action function by one frame (see below; fixes interface bug)
;================================================================================
; Replaces: sb      t8,62(v0)
.org 0x80b5ae44     ; in EnGo2_SetGetItem
    sb      t8,510(s0)

;================================================================================
; Biggoron: In "idle" action function, if EnGo2->reverse is set, unset it and
; return without calling any functions further down (i.e. EnGo2_IsCameraModified)
;================================================================================
; Replaces: lh      v1,28(s0)
;           lbu     t6,513(s0)
;           li      at,1
;           andi    v1,v1,0x1f
.org 0x80b5a768     ; in EnGo2_Action_80A46B40
    jal     EnGo2_BiggoronIdleClaimCheck
    lbu     t6,513(s0)      ; displaced
    bnez    v0,0x80b5a8d8   ; to function end if reverse is set
    andi    v1,v1,0x1f      ; displaced

;================================================================================
; Prevent Goron Link first talk softlock if out of range. Add talkState ==
; NPC_TALK_STATE_TALKING as a condition by itself to update talkState and set textId
;================================================================================
; Replaces: jal Npc_TrackPoint
;           sw  a0,32(sp)
;           lw  a0,32(sp)
;           lw  v0,384(a0)
.org 0x80b58f08         ; in func_80A45288
    jal     EnGo2_TalkstateUpdate
    sw      a0,32(sp)       ; displaced
    bnez    t0,0x80b58f3c   ; if talking, run update talkstate
    nop
