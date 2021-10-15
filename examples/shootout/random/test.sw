#!/usr/bin/sweet

int main() {
	string command, res;

	command = "./random.sweet";
	res = "37.464991998";
	do_test(command, res);

	command = "./random.sweet 5";
	res = "53.854452446";
	do_test(command, res);
}

