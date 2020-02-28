#include <stdio.h>
#include "osd.h"

#include "osd_spritesheet.h"

static int menu=0;
static int lastjoy=0;
static int difficulty=0;
static int cheat=0;

int osd_getdipswitches()
{
	int result=cheat<<11;
	result|=difficulty<<8;
	return(result);
}

void osd_showhide(int visible)
{
	HW_OSD(REG_OSD_VISIBLE)=visible;
	menu=0;
}

void osd_setmsg(enum OSD_Message msg)
{
	lastjoy=0;
	menu=msg;
	osd_draw(0);
}


void osd_draw(int joy)
{
	int reg;
	int row;
	int trigger=0;
	int col=0x3f;
	if(joy!=lastjoy)
	{
		if(joy&1)	/* up */
			menu-=1;
		if(joy&2)	/* down */
			menu+=1;
		if(menu<0)
			menu=1;
		if(menu>1)
			menu=0;

		if(joy&16)	/* fire */
			trigger=1;
		lastjoy=joy;
	}

	switch(menu)
	{
		case 0: /* Difficulty DIP */
			difficulty=(difficulty+trigger)&3;
			row=difficulty*5;
			break;
		case 1: /* Cheat on/off */
			row=4*5;
			cheat=cheat^trigger;
			if(!cheat)
				col=0x17;
			break;
		case 2: /* Loading */
		case 3: /* Error */
		default:
			row=menu*5;
			break;
	}
	HW_OSD(REG_OSD_COLOUR)=col;
	row*=3;
	for(reg=0;reg<5;++reg)
	{
		trigger=(OSD_Spritesheet_bits[row+2]<<16)|(OSD_Spritesheet_bits[row+1]<<8)|OSD_Spritesheet_bits[row];
		HW_OSD(REG_OSD_ROW1+(4*reg))=trigger;
		row+=3;
	}
}

