#!/usr/bin/sweet

int main() {
	string command, res;

	command = "./ary.sweet";
	res = "1000 1000";
	do_test(command, res);

	command = "./ary.sweet 50";
	res = "1000 50000";
	do_test(command, res);
}
