inherit /std/test;

string command, expected_result;

create() {
	int x;

	# Normal test
	command = "5 * 4 ;";
	expected_result = "20";
	do_test(command, expected_result);

	command = "5.0 * 4.2 ;";
	expected_result = "21.0";
	do_test(command, expected_result);

	command = "x * 1";
	expected_result = "0";
	do_test(command, expected_result);

	command = "4 * (-5);";
	expected_result = "-20";
	do_test(command, expected_result);
}
