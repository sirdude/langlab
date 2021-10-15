#!/usr/bin/sweet

int main() {
	string command, res;

	command = "./strcat.sweet";
	res = "6";
	do_test(command, res);

	command = "./strcat.sweet 33";
	res = "198";
	do_test(command, res);
}
