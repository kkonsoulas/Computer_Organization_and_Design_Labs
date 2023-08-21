#include <stdio.h>

#define SIZE 20


int main(void){

	char str1[SIZE] = {'\0'};
	char str2[SIZE] = {'\0'};
	char str3[2*SIZE] = {'\0'};

	int i,j,k;
	printf("Please enter the first string: ");
	scanf("%s",str1);
	printf("Please enter the second string: ");
	scanf("%s",str2);

	for(i=0 ,j=0,k=0; str1[i] && str2[j] ;){
		if(str1[i] < str2[j]){
			str3[k] = str1[i];
			i++;
			k++;
		}
		else{
			str3[k] = str2[j];
			j++;
			k++;
		}
	}

	if(str1[i]){
		do{
			str3[k] = str1[i];
			i++;
			k++;
		}while(str1[i]);
	}
	else{
		do{
			str3[k] = str2[j];
			j++;
			k++;
		}while(str2[j]);
	}

	printf("%s\n",str3);
	return(0);
}