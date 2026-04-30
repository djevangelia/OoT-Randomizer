#ifndef OBJECT_H
#define OBJECT_H

extern int16_t iceTraps;
extern int16_t iceObjects;
extern int16_t totalObj;

bool Object_LoadExtra(z64_game_t* play, int16_t objectId);

#endif