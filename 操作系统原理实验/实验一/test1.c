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
			printf("CHILD:I am the child process!\n");
			printf("CHILD: Here's my PID:%d\n",getpid());
			
			printf("CHILD:My parent's PID is:%d\n",getppid());
			printf("CHILD:The value of fork return is :%d\n",childpid);
			
			printf("CHIlD:Sleep for 5 second...\n");
			sleep(5);
			printf("CHILD:Enter an exit value (0~255):");
			scanf("%d",&retval);
			printf("CHILD:Goodbye!\n");
			exit(retval);
		}
		else{
			printf("PARENT :T amthe parent process!\n");
			printf("PARENT:Here !my PID:sd in",getpid());
			
			printf("PARENT:The value of my child's PID is :%d\n",childpid);
			printf("PARENT: I will now wait for my child to exit.\n");
			wait(&status);
			printf("PARENT: Child's exit code is :%d\n",WEXITSTATUS(status));
			printf("PARENT :Goodbye!\n");
			exit(0);
		}
	}
	else{
		perror("fork error!");
		exit(0);
	}
}
