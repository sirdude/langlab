#!/usr/bin/sweet

int main() {
	string command, res;

	command = "./pidigits.sweet";
	res = "3141592653	:10\n" +
		"5897932384	:20\n" +
		"6264338   	:27\n";
	do_test(command, res);

	command = "./pidigits.sweet 50";
	res = "3141592653	:10\n" +
		"5897932384	:20\n" +
		"6264338327	:30\n" +
		"9502884197	:40\n" +
		"1693993751	:50\n";
	do_test(command, res);
}
