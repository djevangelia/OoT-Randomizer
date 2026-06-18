.headersize (0x808301c0 - 0xbcdb70)

;================================================================================
; Fixes softlock when starting cutscene while dismounting a ladder.
;================================================================================
; Replaces  lw      t8,1644(s0)
;           lui     at,0xffdf
;           ori     at,at,0xffff
;           and     t9,t8,at
.org 0x8084a6c4         ; in Player_Action_DismountLadder (0x803a3064)
    jal     Player_LadderCutsceneFix
    lw      t8,1644(s0)     ; displaced
    bnez    v0,0x8084a6e0   ; branch to load LinkAnimation argument if in CS/using CS item
    nop

;================================================================================
; Call Matrix_Push() and Matrix_Pop() when drawing Bunny Hood and Hover Boots
; hover effect, to avoid very big frozen drawing if frozen
;================================================================================
; Replaces lw      v0,704(s1)
;          lui     t8,0xdb06
.org 0x808482f8
    jal     Player_BunnyMatrixPush
    nop

; Replaces lw      v0,704(s1)
.org 0x808483b4
    jal     Player_BunnyMatrixPop
    ;lui    t3,0xde00          ; Needs to be here because it's a branch target address

; Replaces lwc1    $f12,36(s0)
;          lw      a2,44(s0)
.org 0x8084852c
    jal     Player_HoverMatrixPush
    nop

; Replaces sw      v0,4(s0)
;          lw      v1,720(s1)
.org 0x80848578
    jal     Player_HoverMatrixPop
    sw      v0,4(s0)

;================================================================================
; Prevent softlock if Hookshot actor cannot spawn when equipping
; (memory shortage due to Hyrule Field glitch, child equip etc)
;================================================================================
; Replaces  lw      a1,60(sp)
;           sw      v0,924(a1)
.org 0x808319d4         ; in Player_InitHookshotIA (0x8038a374)
     jal     Player_HookshotCheckActorSpawn
     lw      a1,60(sp)       ; displaced (loads player)

;================================================================================
; Prevent softlock if supersliding into cutscene by adding check in WaitForPutAway
; for specific scene + csAction not none, to change into CS action function.
; Which cutscenes are affected are thus specified in the function.
;================================================================================
; Replaces: lw      a2,24(sp)
;           lw      a1,28(sp)
;           lw      t8,1644(a2)
;           move    a0,a2
.org 0x808439c0         ; in Player_Action_WaitForPutAway
    jal     Player_CSWaitPutAwaySoftlockFix
    lw      a1,28(sp)           ; displaced
    bnez    v0,0x80843a04       ; if CS, run afterPutAwayFunc to exit this action
    lw      t8,1644(a2)         ; displaced; else, continue checks as usual

;================================================================================
; Check if D-pad item should be used, after B and C buttons were not pressed
; but before checking if any button is held. If so, uses D-pad item
;================================================================================
; Replaces  move    a3,zero
;           li      a1,4
;           lhu     a0,0(t3)
;           lhu     v0,0(v1)
.org 0x808320b8             ; in Player_ProcessItemButtons
    jal     Player_CallUseDpadItem
    nop
    bnez    t0,0x80832134       ; used item - go to end of function
    lhu     v0,0(v1)            ; branch target for loop

; Make D-pad down (0x400) cancel first person mode
; Replaces  andi    t8,t7,0xc01f
.org 0x80849394             ; in Player_Action_InFirstPerson
    andi    t8,t7,0xc41f
.headersize(0x808301c0 - 0xbcdb70)

;================================================================================
; Fixes magic getting locked if frozen/electrified during spell cast, i.e. traps
; Also ensures that Farore's Wind doesn't consume magic before actually working
;================================================================================
; Call magic reset upon getting frozen
; Replaces  li      a1,255
;           li      a2,10
.org 0x80835df0                 ; in func_80837C0C
    jal     Player_FrozenElectrifiedMagicReset
    li      a2,10

; Call magic reset upon getting electrified
; Replaces  li      a1,255
;           li      a2,80
.org 0x80835e4c                 ; in func_80837C0C
    jal     Player_FrozenElectrifiedMagicReset
    li      a2,80

; Remove the Farore check for normal consume magic, so that it can be done
; once the respawn data has been set and spell actually worked
; Replaces  bgtz    t3,8084e770
.org 0x8084e71c                 ; in Player_Action_CastMagicSpell
    b       0x8084e770
    ;lui    v0,0x8012 is a branch target

; Consume magic once respawn point has been set
; Replaces  sw      t4,3716(v0)
;           sw      t5,3720(v0)
.org 0x8084e824                 ; in Player_Action_CastMagicSpell
    jal     Player_SetFaroreMagicState
    sw      t4,3716(v0)

;================================================================================
; Remote Hookshot part 1/2. Make player keep holding bottle after drinking full
; milk with empty bottle equipped like in Majora's Mask
;================================================================================
; Replaces: move    a1,s0
;           li      a2,20
.org 0x8084cd3c         ; in Player_Action_DrinkBottle
    jal     Player_DrinkBottle_FullMilk
    move    a1,s0           ; displaced
