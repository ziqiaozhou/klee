/*===-- memcpy.c ----------------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===*/
#include <sched.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/mman.h>
#include <errno.h>

#include <string.h>
#include <stdlib.h>
#include <stdlib.h>
void *mmap(void *start, size_t length, int prot, int flags, int fd, off_t offset) __attribute__((weak));

static int _mmap_prepopulate0(void *addr, size_t length, int fd, off_t offset) {
 size_t remaining = length;
 while(remaining>0){
	size_t s=pread64(fd,addr,remaining,offset);
	if(s<0){
	 errno=EINVAL;
		return -1;
	}
	addr+=s;
	remaining-=s;
	offset+=s;
	
 }
 return 0;
	/*off_t origpos = lseek( fd, SEEK_CUR, 0);

	if (origpos == -1)
	  goto invalid;

	off_t newpos = (lseek, fd, SEEK_SET, offset);
	if (newpos == -1)
	  goto invalid;

	size_t remaining = length;
	char *dest = addr;

	while (remaining > 0) {
		ssize_t res = read(fd, dest, remaining);

		if (res > 0) {
			dest += res;
			remaining -= res;
		} else if (res == 0) {
			// Could not read everything, it's OK
			break;
		} else {
			goto invalid;
		}
	}

	lseek(fd, SEEK_SET, origpos);

	return 0;

invalid:
	if (origpos >= 0)
	  lseek( fd, SEEK_SET, origpos);

	errno = EINVAL;
	return -1;
	*/
}

void *mmap64(void *start, size_t length, int prot, int flags, int fd, off64_t offset) __attribute__((weak));
void *mmap64(void *start, size_t length, int prot, int flags, int fd, off64_t offset) {
	char fdc=0;
	if(fd>0)
	  fdc+=fd;
	char str[]="simulate 00 ";
	str[9]=fdc;
	str[10]=offset;
	klee_warning(str);
	void * result =malloc(length);
	if (!result) {
		errno = ENOMEM;
		return MAP_FAILED;
	}
	memset(result, 0, length);
	if (flags & MAP_ANONYMOUS) {
		if (fd > 0) {
			free(result);
			errno = EINVAL;
			return MAP_FAILED;
		}
	}else{
		int res = _mmap_prepopulate0(result, length, fd, offset);
		if (res == -1) {
			free(result);
			return MAP_FAILED;}
	}
	return result;
}
void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset) {
	return mmap64(addr,length,prot,flags,fd,offset);
}
