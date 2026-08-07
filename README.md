See <https://github.com/OoTRandomizer/OoT-Randomizer> and <https://ootrandomizer.com/>

Contains all my PRs for testing.

If crashing please report with screenshots of the crash debugger screens (press L+R+Z)

Enhancements/options:
- Display grotto and GFF names on entry/pause (display_grotto_names)
- Navi bell item for instant Navi on C up (enable_navi_bell)
- Option to enable bomb OI (enable_bomb_oi)
- Option to enable Remote Hookshot bug from MM (remote_hookshot)
- Able to unequip swords for blank B + set swordless flag

Gameplay fixes:
- Fix Ingo talk post race having wrong textid in overworld ER
- Move flame colliders of slanted torches for easier hit
- Possibility to make opening GTG a permanent flag
- No D-pad boot swap while Hookshot flying unless in lab
- Change conditions for extended minimaps + dynamic load
- Restore interface after giving Biggoron Claim Check
- Change Ruto door drop to Big Octo room only
- Call D-pad items by vanilla function (remove D-pad quickdraw)

Vanilla bugfixes:
- Hookshot parent softlock fix
- Fix superslide Rainbow Bridge CS softlock if not unshielding
- King Zora stop talking bug fix
- Fix ice traps locking magic if casting
- Fix magicFillTarget getting lowered if dying during refill
- Prevent magic add during spellcast from consuming all magic
- Prevent removing main camera pointer by Play_ClearCamera
- Fix adult sword equip when dying as child without sword
- Fix for Epona spawning when entering scene on water
- Fix for adult entering Lake Hylia from Domain swimming if low water level
- Fix Slingshot scrub game softlock when hitting target before receiving item
- Fix Goron Link softlock when talking for first time out of range
- Add Y distance check to business Deku Scrub talk

Minifixes:
- Shorten crash debugger button code to first combo L+R+Z
- Restore A alpha when debug warping during pause
- Object_LoadExtra, note on EffectSs and zero unloaded entry id
- Fixing -Wall warnings
