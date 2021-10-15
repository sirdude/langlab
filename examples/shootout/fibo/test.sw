#!/usr/bin/sweet

int main() {
	string command, res;

	command = "./fibo.sweet";
	res = "1";
	do_test(command, res);

	command = "./fibo.sweet 20";
	res = "10946";
	do_test(command, res);
}
