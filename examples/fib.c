// a fibonacci function showing most features of the CMM language
// Taken from: http://www.cse.chalmers.se/edu/year/2011/course/TIN321/lectures/bnfc-tutorial.html#toc37  
#include <stdio.h>

int mx () {
	return 5000000;
}
  
int main () {
int lo, hi; 

	lo = 1 ;
	hi = lo ;
	printf("%d",lo) ;

	while (hi < mx()) {
		printf("%d",hi) ;
		hi = lo + hi ;
		lo = hi - lo ;
	}
	return 0 ;
}
