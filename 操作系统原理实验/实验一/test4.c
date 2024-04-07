#include "stdio.h"

int main(){
	int count =0;
	int child;
	int i;
	if(!(child = fork())){
		for(i =0;i <10; i++){
			printf("This is son,his countand his pid is: %d\n",++count, getpid());
		}
	}
	else{
		for(i=0;i<10;i++){
			printf("This is father, his count is: td, his pid is: %d\n", count, getpid());
		}
	}
}
