#include <stdio.h>

int IsSymetric(int *array, int N){
	int i,j;
	for(j=0 ;j<N ;j++){
		for(i=j+1 ;i<N ;i++){
			if(array[j*N + i] != array[(i*N + j)]){
				return(0);
			}
		}
	}
	return(1);
} 

int main(){
	int i,N;
	printf("Please give the size N of the square matrix: ");
	scanf("%d",&N);
	
	if(N<=0){
		return(0);
	}

	int array[N*N];

	for(i=0 ;i< N*N ;i++){
		scanf("%d",&array[i]);
	}

	int res = IsSymetric(array,N);
	printf("\nResult: %d\n",res);

	return(0);
}