#!/usr/local/bin/sweet

int mx "Return the Maximum value" () {
	return 5000000;
}
  
int main "Compute Fibonachii function.  Taken from " +
	"http://www.cse.chalmers.se/edu/year/2011/course/TIN321/" +
	"lectures/bnfc-tutorial.html#toc37" () {
	int lo "Lower value";
	int hi "Higher value"; 

	lo = 1;
	hi = lo;
	printf("%d",lo);

	while (hi < mx()) {
		printf("%d",hi);
		hi = lo + hi;
		lo = hi - lo;
	}

	return 0;
}
