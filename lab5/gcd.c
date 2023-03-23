#include <stdio.h>
#include <stdlib.h>

int gcd(int a, int b){
    if (b == 0){
        return a;
    }

    int x = a % b;
    gcd(b, x);
}

int main(){
    int y = gcd(24, 16);
    printf("%d\n", y);
}