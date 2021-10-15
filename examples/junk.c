#include <stdio.h>

int x, y;

/* This is my dumb little function */
int dogarbage(int xx) {
	printf("dograbage called with : %d\n",xx);

	if (xx == x) {	/* Had to create an if statement for something interesting... */
		printf("x=xx.\n");
} else {
		printf("Real x = %d\n",x);
	}

	return x;	/* Yes this is dumb... */
// Test....
}


int main() {
	y = 5;
	x = 21;

printf("Woo Your cool....\n");
printf("X = %d; Y = %d\n", x, y);

	x = dogarbage(y);

	printf("X = %d; Y = %d\n", x, y);

	return 1;
}
