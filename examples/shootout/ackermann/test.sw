#!/usr/bin/sweet

int main() {
	string command, res;

	command = "./ackermann.sweet";
	res = "Ack(3,1): 13";
	do_test(command, res);

	command = "./ackermann.sweet 5";
	res = "Ack(3,5): 253";
	do_test(command, res);
}

