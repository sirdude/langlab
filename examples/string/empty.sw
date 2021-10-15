inherit /std/test;

string command, expected_result;

create() {
	string str;

	# Normal tests
	command = "empty_str(\"WooHoo\");";
	expected_result = "0";
	do_test(command, expected_result);

	command = "empty_str(\"\");";
	expected_result = "1";
	do_test(command, expected_result);

	command = "empty_str(str);";
	expected_result = "1";
	do_test(command, expected_result);
}
