#include <stdio.h>


int main(void){

	int n1,n2,n1_,n2_;
	printf("Give N1:");
	scanf("%d",&n1);
	if(n1<0){
		return(0);
	}
	do{
		printf("\nGive N2:");
		scanf("%d",&n2);
	}while(n2 < n1);
	
	
	while(1){
		printf("Give N1:");
		scanf("%d",&n1_);
		if(n1_<0){
			break;
		}
		do{
			printf("\nGive N2:");
			scanf("%d",&n2_);
		}while(n2_ < n1_ );

		if(n1<=n2_ && n1_<=n2){
			
			n1 = n1<n1_ ? n1 : n1_;
			n2 = n2>n2_ ? n2 : n2_;
		}
		else{//new change (works)
			if(n2_ -n1_ >n2-n1){
				n2 = n2_;
				n1 = n1_;
			}
		}
	}
	
	printf("[%d, %d]",n1,n2);


	return(0);
}
