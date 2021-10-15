inherit /std/test;

string command, expected_result;

int test_if(int x) {
	if (x) {
		return 1;
	} else {
		return 2;
	}
	return 0;
}

create() {
	# Normal test
	command = "test_if(0);";
	expected_result = "2";
	do_test(command, expected_result);

	# Boarder case
	command = "test_if(1)";
	expected_result = "1";
	do_test(command, expected_result);

	# Outside case
	command = "test_while(nil)";
	expected_result = "2";
	do_test(command, expected_result);
}
