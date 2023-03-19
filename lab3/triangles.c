#include <stdio.h>

#define N 4
#define B 1

void print_triangle(int start, int space){
    int increment = 0;
    for(int j = 1; j <= start*N; j++){
        printf("*");
        increment++;

        if(j == start*N){
            // printf("P");    // Checker if no leading space
            break;
        }

        if (increment == start){
            for(int k = 1; k < space; k++){
                printf(" ");
            }
            increment = 0;
        }
        printf(" ");
    }
}

int main(){

    // Upper Half of Triangle
    int spaces = B;
    for(int i = 1; i <= (B/2)+1; i++){
        print_triangle(i, spaces);
        spaces -= 2;
        printf("\n");
    }

    // Lower Half of Triangle
    int spaces2 = 3;
    for(int i = (B/2); i >= 1; i--){
        print_triangle(i, spaces2);          
        spaces2 += 2;

        if(i != 1){
            printf("\n"); 
        }
    }

    return 0;
}