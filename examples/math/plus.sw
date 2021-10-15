inherit /std/test;

string command, expected_result;

create() {
	int x;

	# Normal test
	command = "5 + 4 ;";
	expected_result = "9";
	do_test(command, expected_result);

	command = "5.0 + 4.2 ;";
	expected_result = "9.2";
	do_test(command, expected_result);

	command = "x + 1";
	expected_result = "1";
	do_test(command, expected_result);

	command = "4 + (-5);";
	expected_result = "-1";
	do_test(command, expected_result);
}
