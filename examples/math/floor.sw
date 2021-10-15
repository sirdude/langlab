inherit /std/test;

string command, expected_result;

create() {
	# Normal test
	command = "floor(5);";
	expected_result = "5.0";
	do_test(command, expected_result);

	command = "floor(5.1);";
	expected_result = "5.0";
	do_test(command, expected_result);

	command = "floor(5.9);";
	expected_result = "5.0";
	do_test(command, expected_result);

	command = "floor(-1.2);";
	expected_result = "-2.0";
	do_test(command, expected_result);

	command = "floor(-1);";
	expected_result = "-1.0";
	do_test(command, expected_result);

	command = "floor("a");";
	expected_result = "nil";
	do_test(command, expected_result);

	command = "floor("");";
	expected_result = "nil";
	do_test(command, expected_result);
}
