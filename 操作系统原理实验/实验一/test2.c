#include <unistd.h>
#include <sys/types.h>
#include <errno.h>
#include <stdlib.h>

int main(){
	pid_t childpid;
	int retval;
	int status;

	childpid=fork();
	if(childpid>=0){
		if(childpid==0){
			printf("CHlLD: I am the child process !\n");
			sleep(20);
			execlp("ls", "ls","-a", "-l", NULL);
			exit(0);
		}
		else{
			printf("PARENT: I am the parent process!\n");
			printf("PARENT: Here's my PiD: %d \n",getpid());
		}
	}
	else{
		perror("fork error!");
		exit(0);
	}
}


