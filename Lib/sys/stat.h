#ifndef STAT_H
#define STAT_H

#include <stddef.h>

#define S_IFBLK 0
#define S_IFCHR 1

struct stat
{
	int st_mode;
	size_t st_size;
	size_t st_blksize;
};

int fstat(int fd, struct stat *buf);

#endif

