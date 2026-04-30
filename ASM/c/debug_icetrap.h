#ifndef DEBUG_ICETRAP_H
#define DEBUG_ICETRAP_H

#include "z64.h"
#include "gfx.h"
#include "text.h"

// Ice trap debug

extern int16_t iceTraps;
extern int16_t iceObjects;
extern int16_t totalObj;
extern bool    drawIceTrapDebug;

void IceTrapObjectDebugDraw(z64_disp_buf_t* db);

#endif