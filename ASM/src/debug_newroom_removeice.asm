NewRoomRemoveIce:
    la      t6,iceTraps
    sb      zero,(t6)
    jr      ra
    lb      t6,49(s0)
