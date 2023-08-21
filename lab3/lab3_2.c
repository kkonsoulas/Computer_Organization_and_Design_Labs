#include <stdio.h>

int mypow(int n, int m) {
    if (m == 1)
        return n;
    return n * mypow(n, m-1);
}

int main(void){

    int m,n;
    printf("Give m and n: ");
    scanf("%d %d",&m,&n);
    printf("%d\n",mypow(n,m));
    return(0);
}

