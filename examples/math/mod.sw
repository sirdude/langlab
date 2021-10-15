inherit /std/test;

string command, expected_result;

create() {
	# Normal test
	command = "mod(5,2);";
	expected_result = "1";
	do_test(command, expected_result);

	command = "mod(5,5);";
	expected_result = "0";
	do_test(command, expected_result);

	command = "mod(5,1);";
	expected_result = "0";
	do_test(command, expected_result);

	command = "mod(5,-1);";
	expected_result = ""; XXX ???
	do_test(command, expected_result);

	command = "mod(5,10);";
	expected_result = ""; XXX ???
	do_test(command, expected_result);
}
