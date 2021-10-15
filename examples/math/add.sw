inherit /std/test;

string command, expected_result;

create() {
	# Normal test
	command = "5 + 5;";
	expected_result = "10";
	do_test(command, expected_result);

	command = "5 + 5.0;";
	expected_result = "10.0";
	do_test(command, expected_result);

	command = "\"Woo \" + 5 ";
	expected_result = "Woo 5";
	do_test(command, expected_result);

	command = ".003 + .02 ";
	expected_result = ".023";
	do_test(command, expected_result);
}
