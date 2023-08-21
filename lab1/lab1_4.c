#include <stdio.h>

int main(void){
	int v1[5];
	int v2[5];
	int i,total,size;
	//Get Vectors Size
	printf("Please enter the size of the vectors: ");
	scanf("%d",&size);
	
	//Get Vector x 
	for(i=0 ;i<size ;i++){
		printf("Enter element %d of vector x: ",i);
		scanf("%d",&v1[i]);
	}
	//

	//Print Vector x
	printf("x=[");
	for(i=0; i<size-1 ;i++){
		printf("%d ",v1[i]);
	}
	printf("%d]\n\n",v1[i]);
	//



	//Get Vector y
	for(i=0 ;i<size ;i++){
		printf("Enter element %d of vector y: ",i);
		scanf("%d",&v2[i]);
	}

	//Print Vector y
	printf("y=[");
	for(i=0; i<size-1 ;i++){
		printf("%d ",v2[i]);
	}
	printf("%d]\n\n",v2[i]);



	//Calc
	for(i=0,total=0;i<size ;i++){
		total += v1[i] * v2[i];
	}

	printf("The inner product of x*y is: %d\n",total);

	return(0);
}