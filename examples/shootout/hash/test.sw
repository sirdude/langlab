#!/usr/bin/sweet

int main() {
	string command, res;

	command = "./hash.sweet";
	res = "1";
	do_test(command, res);

	command = "./hash.sweet 20";
	res = "14";
	do_test(command, res);
}
