/*
	--stop-time=1ms
*/

#include <stdio.h>

char filename[16];
int main(int argc,char **argv)
{
	filename[0]='H';
	filename[1]='e';
	filename[2]='l';
	filename[3]='l';
	filename[4]='o';
	filename[5]=',';
	filename[6]=' ';
	filename[7]='W';
	filename[8]='o';
	filename[9]='r';
	filename[10]='l';
	filename[11]='d';
	filename[12]='\n';
	filename[13]=0;
	puts(filename);
	return(0);
}
