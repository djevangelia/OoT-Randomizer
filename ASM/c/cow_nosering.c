#include "z_en_cow.h"
#include "models.h"
#include "z64_math.h"
#include "z64.h"
#include "util.h"

#include "gfx.h"
#include "chests.h"

extern uint8_t SHUFFLE_COWS;
extern int32_t Flags_GetCollectible(z64_game_t* play, int32_t flag);

int32_t EnCow_OverrideLimbDrawNew(z64_game_t* play, int32_t limbIndex, Gfx** dList, z64_xyzf_t* pos, z64_xyz_t* rot, void* thisx) {
    EnCow* this = (EnCow*)thisx;

    if (limbIndex == COW_LIMB_HEAD) {
        rot->y += this->headRot.y;
        rot->x += this->headRot.x;
    }

    if (limbIndex == COW_LIMB_NOSE_RING) {
        if (!SHUFFLE_COWS || (!CHEST_SIZE_MATCH_CONTENTS && !CHEST_SIZE_TEXTURE && !CHEST_TEXTURE_MATCH_CONTENTS)) {
            *dList = NULL;
        }
    }

    return false;
}

void* EnCow_ColorNoseRing(z64_game_t* play, EnCow* this, Gfx** dList) {
    z64_gfx_t* gfx = play->common.gfx;
    colorRGBA8_t color = (colorRGBA8_t){255,255,255,255};
    const int16_t cowId = this->actor.rot_init.x;

    // dList not null already checked in asm = shuffle cows is on (hopefully?)
    // might want to do different things depending on chest setting, so keeping them here
    if (cowId != 0 && (CHEST_SIZE_MATCH_CONTENTS || CHEST_SIZE_TEXTURE || CHEST_TEXTURE_MATCH_CONTENTS) &&
        !Flags_GetCollectible(play, 23+cowId)) {
        // code from chest
        override_t override = lookup_override(&this->actor, play->scene_index, cowId + 0x14);

        if (override.value.base.item_id != 0) {
            item_row_t* item_row = get_item_row(override.value.looks_like_item_id);

            if (item_row == NULL) {
                item_row = get_item_row(override.value.base.item_id);
            }

            if (item_row != NULL) {
                if (item_row->chest_type == BROWN_CHEST) {
                    color = (colorRGBA8_t){255,255,255,255};
                } else if (item_row->chest_type == SILVER_CHEST || item_row->chest_type == SKULL_CHEST_SMALL ||
                    item_row->chest_type == HEART_CHEST_SMALL) {
                    color = (colorRGBA8_t){200,0,100,100};
                } else if (item_row->chest_type == GOLD_CHEST || item_row->chest_type == GILDED_CHEST) {
                    color = (colorRGBA8_t){0,100,132,100};
                } else {
                    color = (colorRGBA8_t){0,0,0,255}; // what chests ?
                }
            }
        } else {
            color = (colorRGBA8_t){0,0,200,100}; // what cases ?
        }
    } else {
       // cows without item, item already get
    }
    // add color at the top of the ring display list
    gDPSetPrimColor(gfx->poly_opa.p++, 0, 0x80, color.r, color.g, color.b, color.a);

    return gfx->poly_opa.p; // ugly but ensures return asm has correct pointer
}
