#define _GNU_SOURCE
#include <stdio.h>
#include <errno.h>
#include <sched.h>
#include <sys/types.h>
#define STACK_SIZE 4096

int flag;
void *test(void *arg){
	int childnum;
	flag=1;
	childnum=*(int *)arg;
	printf("Thread %d work cycle.\n",childnum);
	sleep(3);
	exit(0);
}

int main(){
	pid_t pid;
	int childno=1,mainnum=0;
	void *csp,*tcsp;
	csp=(char *)malloc(STACK_SIZE);	
	
	if (csp){
		tcsp=csp+STACK_SIZE;
	}
	else{
		exit(errno);
	}
	
	flag=0;
	childno=1;
	if((pid=clone((void *)&test,tcsp,CLONE_VFORK,(void *)&childno))<0){
		printf("Couldn't create new thread!\n");
		exit(1);
	}
	else{
		while(flag==0){	
			printf("Just created thread %d\n",pid);
			break;
		}
	}
	
	test(&mainnum);
	sleep(3);
	printf("Main program is now shutting down\n");
	
	return 0;
}

