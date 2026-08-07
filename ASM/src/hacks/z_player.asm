.headersize(0x808301c0 - 0xbcdb70)

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
; Prevent softlocking when pulling out Hookshot if player->actor.parent is set
; but is not Hookshot actor
;================================================================================
; Replaces: jal     Player_HoldsHookshot
;           move    a0,s0
.org 0x80834764         ; in Player_UpdateUpperBody
    jal     Player_UpperBodyCheckParent
    move    a0,s0       ; displaced

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

;==================================================================================
; 1. Fixes Epona spawning on water when exiting into a water entrance while riding.
; 2. Prevents Link from swimming when entering Domain to Lake when low water.
;==================================================================================
; Replaces      sub.s   $f10,$f6,$f8
;               move    a0,s1
;               move    a1,s0
;               swc1    $f10,40(sp)
;               lw      t8,1640(s0)
;               lwc1    $f16,36(t8)
.org 0x8083aa1c                     ; in Player_SetStartingMovement
    sub.s   $f12,$f6,$f8            ; (waterbox Y surface - player Y) = ySurface
    move    s7,a2                   ; store Player_Action_StartModeWater address
    jal     Player_CallCheckEponaWater
    swc1    $f12,40(sp)             ; store new ySurface (restored in end of jal to $f10)
    bnez    v0,0x8083aa98           ; not swim entry
    nop

;================================================================================
; Bomb OI
; Backport Bomb OI
; 1. Restore first part of CarryActor upper action function
; 2. Make the explosives part of DetachHeldActor always run for bomb OI:
; a) in start of function, check for setting and choose which address to jump to
; later when returned to the function (the entire heldActor + Hookshot check is
; moved to the function)
; b) reorder the transition between pre-check and explosives check to allow jump
; 3) Don't run old rando empty bomb fix if setting enabled (see empty bomb)
;================================================================================
; 1)
; Replaces: move    s0,a0
;           move    s1,a1
;           sw      ra,28(sp)
.org 0x8083377c     ; Player_UpperAction_CarryActor
    sw      ra,28(sp)   ; displaced
    jal     Player_CarryActorSetUpperIA
    move    s0,a0       ; displaced

; 2a)
; Replaces: sw      a0,40(sp)
;           lw      v1,924(s0)
;           move    a0,s0
;           beqzl   v1,808303fc
;           lw      ra,28(sp)
;           jal     Player_HoldsHookshot
;           sw      v1,36(sp)
;           bnez    v0,808303f8
.org 0x80830390     ; Player_DetachHeldActor
    jal     Player_DetachActorCheckBomb
    sw      a0,40(sp)       ; displaced
    bnez    v0,@@Branch     ; if no heldActor, or heldActor is Hookshot
    nop                     ; then return if normal, if bomb OI run explosives check
    b       0x808303b4      ; if have heldActor - run function normally
    nop
@@Branch:
    jr      t9      ; branch to explosives check "1.1" or return, depending on setting
    nop

; 2b)
; Replaces: li      at,-2049
;           move    a0,s0
;           and     t7,t6,at
;           jal     Player_GetExplosiveHeld
;           sw      t7,1644(s0)
.org 0x808303c8     ; Player_DetachHeldActor
    li      at,-2049    ; change order of instructions to allow branching from higher up
    and     t7,t6,at
    sw      t7,1644(s0)
    jal     Player_GetExplosiveHeld
    move    a0,s0

;================================================================================
; Allow use of button items that don't run normal UseItems pathway
;================================================================================
; Replaces: jal     Player_UseItem
;           lw      a0,44(sp)
.org 0x8083212c     ; Player_ProcessItemButtons
    jal     Player_UseItemCustom
    lw      a0,44(sp)

.org 0x80853520
    nop     ; reloc, nop Player_UseItem in Player_ProcessItemButtons
