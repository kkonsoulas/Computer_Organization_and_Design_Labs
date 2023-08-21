#include <stdio.h>
#include <stdlib.h>


typedef struct new_node {
	int data;
	struct new_node *next;
} nodeL;

 void printList (nodeL *head){
	if(head == NULL)
		return;
	printf("%d ",head->data);
	printList(head->next);
 }

nodeL* insertElement(nodeL *head, int data){

	//Print
	


	//Create Node
	nodeL *new_node = malloc(sizeof(nodeL));
	if(new_node == NULL){
		printf("Not enough memory!\n");
		return(0);
	}

	new_node->data = data;



	//If empty list
	if(head == NULL){
		new_node->next = NULL;
		return(new_node);
	}

	//if new_node needs to become head
	if(head->data > new_node->data){
		new_node->next = head;
		return(new_node);
	}

	//find new node's position
	nodeL *tmp;
	for(tmp = head ;tmp->next && tmp->next->data < new_node->data ;tmp = tmp->next);

	//Inject
	new_node->next = tmp->next;
	tmp->next = new_node;
	return(head);


}


int main(void){

	nodeL *myhead = NULL;
	int data;
	printf("give data: ");
	scanf("%d",&data);
	while(data){
		myhead = insertElement(myhead,data);
		
		printf("give data: ");
		scanf("%d",&data);
	}

	printf("List(");
	printList(myhead);
	printf("\b)\n");





	return(0);
}
