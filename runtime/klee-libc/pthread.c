#include<stdlib.h>
#include <pthread.h>
#include <errno.h>

#include <klee/klee.h>
int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
			    void *(*start_routine)(void*), void *arg) {
	klee_warning("run thread function blocking");
	start_routine(arg);
	klee_warning("finish run");
}
int pthread_join(pthread_t thread, void **retval){
	
	klee_warning("simulate join");
	return 0;
}

