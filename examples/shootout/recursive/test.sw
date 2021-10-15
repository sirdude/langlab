#!/usr/bin/sweet

int main() {
	string command, res;

	command = "./recursive.sweet";
	res = "Ack(3,0): 5\n" +
		"Fib(27.0): 317811.0\n" +
		"Tak(-3,-2,-1): -1\n" +
		"Fib(3): 3\n" +
		"Tak(3.0,2.0,1.0): 2.0\n";
	do_test(command, res);

	command = "./recursive.sweet 10";
	res = "Ack(3,10): 8189\n" +
		"Fib(37.0): 39088169.0\n" +
		"Tak(27,18,9): 18\n" +
		"Fib(3): 3\n" +
		"Tak(3.0,2.0,1.0): 2.0\n";
	do_test(command, res);
}

