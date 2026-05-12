#include "debug_icetrap.h"

#define ARRAY_COUNT(arr) (int32_t)(sizeof(arr) / sizeof(arr[0]))

uint8_t iceTraps = 0;
uint8_t iceObjects = 0;
uint8_t totalObj = 0;
uint8_t drawIceTrapDebug = 0;

// Draw number of ice trap chests in room, number of OBJECT_FZ objects and slot, total loaded objects
// and list of slots
void IceTrapObjectDebugDraw(z64_disp_buf_t* db) {
    uint8_t i;
    colorRGBA8_t color = { 0xFF, 0xFF, 0xFF, 0xFF };
    colorRGBA8_t color_obj = { 0, 0, 0xaa, 0xFF };
    colorRGBA8_t color_empty = { 0xaa, 0xaa, 0xaa, 0xFF };
    iceObjects = totalObj = 0;

    for (i = 0; i < ARRAY_COUNT(z64_game.obj_ctxt.objects); i++) {
        uint16_t displX = 12+12*(i % 10);
        uint16_t displY = 160 + (i < 10 ? 0 : 1) * 16;
        if ((z64_game.obj_ctxt.objects[i].id) != 0) {
            totalObj++;
            if(ABS((z64_game.obj_ctxt.objects[i].id)) == 0x114) {
                iceObjects++;
                draw_int(db, i, 20, 80, color_obj); // hopefully no more than one object_fz
                draw_int(db, 2, displX, displY, color_obj); // object_fz slot
            } else {
                draw_int(db, 1, displX, displY, color); // used slots
            }
        } else {
            draw_int(db, 0, displX, displY, color_empty); // empty slots
        }
    }

    draw_int(db, iceTraps, 20, 60, color);
    //draw_int(db, iceObjects, 20, 80, color);
    draw_int(db, totalObj, 20, 100, color);

}
