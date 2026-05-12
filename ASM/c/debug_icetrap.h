#ifndef DEBUG_ICETRAP_H
#define DEBUG_ICETRAP_H

#include "z64.h"
#include "gfx.h"
#include "text.h"

// Ice trap debug

extern uint8_t iceTraps;
extern uint8_t iceObjects;
extern uint8_t totalObj;
extern uint8_t drawIceTrapDebug;

void IceTrapObjectDebugDraw(z64_disp_buf_t* db);

#endif