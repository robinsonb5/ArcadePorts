#include "osd.h"

#include "osd_spritesheet.h"

static char menu=0;
static char lastjoy=0;
static char difficulty=0;
static char cheat=0;

void osd_showhide(int visible)
{
	HW_OSD(REG_OSD_VISIBLE)=visible;
}

void osd_setmsg(enum OSD_Message msg)
{
	lastjoy=0;
	menu=msg;
	osd_draw(0);
}

void osd_draw(int joy)
{
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
	}
	switch(menu)
	{
		case 0: /* Difficulty DIP */
			difficulty=(difficulty+trigger)&3;
			row=difficulty*5;
			break;
		case 1: /* Cheat on/off */
			cheat=cheat^trigger;
			if(!cheat)
				col=0x17;
			/* fall through */
		case 2: /* Loading */
		case 3: /* Error */
		default:
			row=menu+3;
			break;
	}
	HW_OSD(REG_OSD_COLOUR)=col;
	row*=3;
	trigger=(OSD_Spritesheet_bits[row+2]<<16)|(OSD_Spritesheet_bits[row+1]<<8)|OSD_Spritesheet_bits[row+0];
	HW_OSD(REG_OSD_DATA)=trigger;
}

