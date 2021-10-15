#!/usr/bin/sweet

int main() {
	string command, res;

	command = "./lists.sweet";
	res = "10000";
	do_test(command, res);

	command = "./lists.sweet 20";
	res = "10000";
	do_test(command, res);
}
