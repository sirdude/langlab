#!/usr/bin/sweet

int main() {
	command = "./nestedloop.sweet";
	res = "1";
	do_test(command, res);

	command = "./nestedloop.sweet 20";
	res = "64000000";
	do_test(command, res);
}
