inherit /std/test;

string command, expected_result;

test_foreach(int *x) {
	int i;
	string str;

	str = "";
	foreach i (x) {
		str += i + ", ";
	}
	str += "\n";

	return str;
}

create() {
	int *x;

	x = [0..10]; # This is shorthand for x[0] = 0; x[1] = 1; ...
	command = "test_foreach(x);";
	expected_result = "1, 2, 3, 4, 5, 6, 7, 8, 9, 10, \n";
	do_test(command, expected_result);

	command = "test_foreach(nil)";
	expected_result = "\n";
	do_test_command, expected_result);
}
