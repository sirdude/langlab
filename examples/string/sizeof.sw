inherit /std/test;

string command, expected_result;

create() {
	string str;

	# Normal tests
	command = "sizeof(\"abcdef\"");
	expected_result = "6";
	do_test(command, expected_result);

	command = "sizeof(\"\"");
	expected_result = "0";
	do_test(command, expected_result);

	command = "sizeof(str);
	expected_result = "0";
	do_test(command, expected_result);

}
