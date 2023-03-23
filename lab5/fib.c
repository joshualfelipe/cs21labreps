#include <stdio.h>
#include <stdlib.h>

int fib(int a, int b, int n, int counter){
	if(counter == n){
		return a + b;
	}

	if(counter % 2 == 0){
		a = a + b;
		// printf("a = %d\n", a);
	}

	else{
		b = a + b;
		// printf("b = %d\n", b);
	}
	
	// printf("counter = %d\n", counter);
	counter++;
	fib(a, b, n, counter);
}

/*
x = 3
y = 7
n = 5

output: 3 7 10 17 27 44

x = 10
y = 12
n = 3

output: 10 12 22 34

x = 0
y = 1
n = 10

output: 0 1 1 2 3 5 8 13 21 34 55

x = 0
y = 1
n = 2

output: 0 1 1
*/

int main(){
	int x = fib(4,5,5,2);
	printf("x = %d\n", x);
	return 0;
}