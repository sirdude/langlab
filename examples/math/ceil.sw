inherit /std/test;

string command, expected_result;

create() {
	# Normal test
	command = "ceil(5);";
	expected_result = "5.0";
	do_test(command, expected_result);

	command = "ceil(5.1);";
	expected_result = "6.0";
	do_test(command, expected_result);

	command = "ceil(5.9);";
	expected_result = "6.0";
	do_test(command, expected_result);

	command = "ceil(-1.2);";
	expected_result = "-1.0";
	do_test(command, expected_result);

	command = "ceil(-1);";
	expected_result = "-1.0";
	do_test(command, expected_result);

	command = "ceil("a");";
	expected_result = "nil";
	do_test(command, expected_result);

	command = "ceil("");";
	expected_result = "nil";
	do_test(command, expected_result);
}
