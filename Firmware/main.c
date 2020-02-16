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

#define Breadcrumb(x) HW_UART(REG_UART)=x;

#define UPLOADBASE 0xFFFFFFF8
#define UPLOAD_ENA 0
#define UPLOAD_DAT 4
#define HW_UPLOAD(x) *(volatile unsigned int *)(UPLOADBASE+x)

/* Upload data to FPGA */

void SendBlock(const char *buf,int size)
{
//	SPI_ENABLE(HW_SPI_FPGA);
//	SPI(SPI_FPGA_FILE_TX_DAT);
	while(size--)
	{
		HW_UPLOAD(UPLOAD_DAT)=*buf++;
//		SPI(*buf++);
	}
//	SPI_DISABLE(HW_SPI_FPGA);
}

fileTYPE file;

int SendFile(const char *fn)
{
	if(FileOpen(&file,fn))
	{
		int imgsize=file.size;
		int sendsize;
		puts("Opened file, loading...\n");

//		SPI_ENABLE(HW_SPI_FPGA);
//		SPI(SPI_FPGA_FILE_TX);
//		SPI(0xff);
//		SPI_DISABLE(HW_SPI_FPGA);

		HW_UPLOAD(UPLOAD_ENA)=1;

		while(imgsize)
		{
			if(!FileRead(&file,sector_buffer))
				return(0);
			FileNextSector(&file);

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
			SendBlock(sector_buffer,sendsize);
		}
		HW_UPLOAD(UPLOAD_ENA)=0;
//		SPI_ENABLE(HW_SPI_FPGA);
//		SPI(SPI_FPGA_FILE_TX);
//		SPI(0x00);
//		SPI_DISABLE(HW_SPI_FPGA);
	}
	else
	{
		printf("Can't open %s\n",fn);
		return(0);
	}
	return(1);
}


int spin()
{
	int i,t;
	for(i=0;i<1024;++i)
		t=HW_SPI(HW_SPI_CS);
}

char filename[16];
int main(int argc,char **argv)
{
	int havesd;
	int i,c;

	puts("Fetching conf string\n");
	filename[0]=0;

	SPI_ENABLE(HW_SPI_CONF);
	SPI(SPI_CONF_READ); // Read conf string command
	i=0;
	while(c=SPI(0xff))
	{
		filename[i]=c;
		spin();
		putchar(c);
		if(c==';')
		{
			if(i<8)
			{
				for(;i<8;++i)
					filename[i]=' ';
			}
			else if(i>8)
			{
				filename[6]='~';
				filename[7]='1';
			}
			filename[8]='R';
			filename[9]='O';
			filename[10]='M';
			filename[11]=0;
			break;
		}
		++i;
	}
	while(c=SPI(0xff))
		;
	SPI_DISABLE(HW_SPI_CONF);

	spin();
	puts(filename);

	puts("Initializing SD card\n");
	havesd=spi_init() && FindDrive();

	if(havesd && SendFile(filename))
	{
		puts("Done\n");
	}
	else
		puts("SD boot failed\n");

	return(0);
}

