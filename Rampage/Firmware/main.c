/*	Firmware for loading files from SD card.
	Part of the ZPUTest project by Alastair M. Robinson.
	SPI and FAT code borrowed from the Minimig project.
*/


#include "stdarg.h"

#include "uart.h"
#include "spi.h"
#include "minfat.h"
#include "cachecontrol.h"
#include "printf.h"
#include "keyboard.h"
#include "pausecpu.h"
#include "osd.h"

#define Breadcrumb(x) HW_UART(REG_UART)=x;

#define UPLOADBASE 0xFFFFFFF4
#define UPLOAD_STATUS 0
#define UPLOAD_ENA 4
#define UPLOAD_DAT 8
#define HW_UPLOAD(x) *(volatile unsigned int *)(UPLOADBASE+x)

#define HOSTBASE 0xFFFFFF40

#define HW_HOST(x) *(volatile unsigned int *)(HOSTBASE+x)
#define HW_HOST_SW 0x0
#define HW_HOST_BUTTONS 0x04
#define HW_HOST_GAMEPAD 0x08


fileTYPE file;

char filename[16];
int main(int argc,char **argv)
{
	int havesd;
	int i,c;
	int menu=0;

	puts("Initializing SD card\n");
	havesd=spi_init() && FindDrive();

	if(havesd && FileOpen(&file,"RAMPAGE ROM"))
	{
		char *buf;
		int imgsize=file.size;
		int sendsize;
		osd_showhide(1);
		osd_setmsg(OSD_LOADING);

		puts("Opened file, loading...\n");

		HW_UPLOAD(UPLOAD_ENA)=1;

		while(imgsize)
		{
			if(!FileRead(&file,sector_buffer))
				return(0);

			if(imgsize>=512)
			{
				sendsize=512;
				imgsize-=512;
			}
			else
			{
				sendsize=imgsize;
				imgsize=0;
			}
			buf=sector_buffer;
			while(sendsize--)
			{
				HW_UPLOAD(UPLOAD_DAT)=*buf++;
			}
			FileNextSector(&file);
		}
		HW_UPLOAD(UPLOAD_ENA)=0;

		puts("Done\n");
		osd_showhide(0);
	}
	else
	{
		osd_showhide(1);
		osd_setmsg(OSD_ERROR);
		puts("SD boot failed\n");
		while(1)
			pausecpu();
	}

	while(1)
	{
		int joya=0;
		int joyb=0;
		int joyc=0;
		int buttons=0;

		if(TestKey(KEY_CAPSLOCK))
			joyc|=0x20;
		if(TestKey(KEY_LSHIFT))
			joyc|=0x10;
		if(TestKey(KEY_LCTRL))
			joyc|=0x20;
		if(TestKey(KEY_ALT))
			joyc|=0x10;
		if(TestKey(KEY_W))
			joyc|=0x01;
		if(TestKey(KEY_S))
			joyc|=0x02;
		if(TestKey(KEY_A))
			joyc|=0x04;
		if(TestKey(KEY_D))
			joyc|=0x08;

		if(TestKey(KEY_ENTER))
			joya|=0x10;
		if(TestKey(KEY_RSHIFT))
			joya|=0x20;
		if(TestKey(KEY_RCTRL))
			joya|=0x10;
		if(TestKey(KEY_ALTGR))
			joya|=0x20;
		if(TestKey(KEY_UPARROW))
			joya|=0x01;
		if(TestKey(KEY_DOWNARROW))
			joya|=0x02;
		if(TestKey(KEY_LEFTARROW))
			joya|=0x04;
		if(TestKey(KEY_RIGHTARROW))
			joya|=0x08;

		if(TestKey(KEY_N))
			joyb|=0x10;
		if(TestKey(KEY_B))
			joyb|=0x20;
//		if(TestKey(KEY_LCTRL))
//			joyb|=0x20;
//		if(TestKey(KEY_ALT))
//			joyb|=0x10;
		if(TestKey(KEY_I))
			joyb|=0x01;
		if(TestKey(KEY_K))
			joyb|=0x02;
		if(TestKey(KEY_J))
			joyb|=0x04;
		if(TestKey(KEY_L))
			joyb|=0x08;


		if(TestKey(KEY_5))
			buttons|=0x01;
		if(TestKey(KEY_6))
			buttons|=0x02;
		if(TestKey(KEY_7))
			buttons|=0x04;
		if(TestKey(KEY_1))
			buttons|=0x08;
		if(TestKey(KEY_2))
			buttons|=0x10;
		if(TestKey(KEY_3))
			buttons|=0x20;

		if(TestKeyStroke(KEY_F12))
		{
			AcknowledgeKey(KEY_F12);
			menu ^= 1;
			osd_showhide(menu);
			printf("Show menu %d\n",menu);
//			if(!menu)
//			{
				// Reset the core to make switches take effect.
//			}
		}

//		HW_HOST(HW_HOST_SWITCHES)=switches;
		HW_HOST(HW_HOST_BUTTONS)=buttons;
		HW_HOST(HW_HOST_GAMEPAD)=(joya << 16) | (joyb <<8) | joyc;

		if(menu)
		{
			osd_draw(joya);
		}

		pausecpu();
		KeyboardHandler();
	}

	return(0);
}

