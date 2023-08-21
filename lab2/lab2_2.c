#include <stdio.h>

int substring(char *str, char *substring){
	char *substr_ptr,*search_pos = NULL;
	int counter=0,max=0, trigger;
	substr_ptr = substring;

	while(*str){
		trigger = (*str == *substr_ptr);
		while(trigger){ //while str[i] and substr[j] are same 

			counter++;
			str++; //next pos
			substr_ptr++; //next pos
			//if end of substr then return it's counted size
			if(*substr_ptr == 0 /*\n*/){
				return(counter);
			}
			// Store next possible start of the substring in the string
			if(*str == *substring && !search_pos){
				search_pos = str;
			}

			if(*str == 0/*== \n */){
				max = counter > max ? counter : max;
				return max;
			}

			trigger = (*str == *substr_ptr); //!= 10 //evaluate that str[i] == substr[j] and we have str
			//if not evaluate the max and reset values
			if(!trigger){
				max = counter > max ? counter : max;
				counter=0; 
				substr_ptr = substring;
			}
			
		}

		if(search_pos){
			str = search_pos;
			search_pos = NULL;
		}
		else{
			str++;
		}
		
	
	}

	return(max);

}

int main(void){

	//char str[12] = { "alloavcllof"};
	//char substr[5] = {"llof"};
	char str[] = {"g"};
	char substr[] = {"gh"};

	int size = substring(str,substr);
	printf("Size:%d\n",size);
	return(0);
}