#include <stdio.h>

int main(void){
	float a = 1.75;
	double b = 1.75;

	if((double) a == b){
		printf("Equal!\n");
	}
	else{
		printf("NOT Equal\n");
	}

	return(0);
}