inherit /std/test;

string command, expected_result;

create() {
	int x;

	# Normal test
	command = "20 / 4 ;";
	expected_result = "5";
	do_test(command, expected_result);

	command = "21.0 * 4.2 ;";
	expected_result = "5.0";
	do_test(command, expected_result);

	command = "x / 1";
	expected_result = "nil";
	do_test(command, expected_result);

	command = "20 / (-5);";
	expected_result = "nil";
	do_test(command, expected_result);
}
