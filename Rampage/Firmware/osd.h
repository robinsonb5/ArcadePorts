#ifndef OSD_H
#define OSD_H

#define OSDBASE 0xFFFFFE00
#define HW_OSD(x) *(volatile unsigned int *)(OSDBASE+x)

#define REG_OSD_VISIBLE 0
#define REG_OSD_COLOUR 0x4
#define REG_OSD_ROW1 0x8
#define REG_OSD_ROW2 0xc
#define REG_OSD_ROW3 0x10
#define REG_OSD_ROW4 0x14
#define REG_OSD_ROW5 0x18


enum OSD_Message {OSD_LOADING=5,OSD_ERROR};

void osd_showhide(int visible);
void osd_setmsg(enum OSD_Message msg);
void osd_draw(int joy);
int osd_getdipswitches();

#endif

