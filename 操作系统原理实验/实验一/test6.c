#include"stdio.h"
int main(){
	int count =0;
	int child;
	int i;
	
	if(!(child = vfork())){
		for(i =0;i <10;i++){
			printf("This is son,his count is:%d. and his pid is:%d\n",++count,getpid());
		}
		exit(0);
	}
	else{
		for(i=0;i<10;i++){
			printf("This is father, his count is: %d, his pid is: %d\n", count, getpid());
		}
	}
}

