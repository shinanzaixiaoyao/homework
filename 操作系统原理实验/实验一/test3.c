#include "stdio.h"
#include "stdlib.h"
#include "sys/types.h"
#include "unistd.h"

int main(void){
	int count =1;
	int child;
	child= fork();
	printf("Before create son,the father's cout is:%d\n", count);
	
	if((child =fork())< 0){
		perror("fork error:");
	}
	else if(child==0){
		printf("This is son,his count is: %d (%p), and his pid is: %d\n", ++count, &count, getpid());
		sleep(15);
		exit(0);
	}
	else{
		printf("This is father, his count is: %d (%p), his pid is: %d\n", count, &count, getpid());
		sleep(5);
		exit(0);
	}
	
	return EXIT_SUCCESS;
}

