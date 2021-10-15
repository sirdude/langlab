inherit /std/test;

string command, expected_result;

create() {
	string str, *arr;
	int x;
	mapping y;
	mixed z;

	# Normal tests
	command = "strp(\"abcde\");";
	expected_result = "1";
	do_test(command, expected_result);

	command = "strp(\"\";";
	expected_result = "1";
	do_test(command, expected_result);

	command = "strp(1);";
	expected_result = "0";
	do_test(command, expected_result);

	command = "strp(str);";
	expected_result = "1";
	do_test(command, expected_result);

	command = "strp(arr);";
	expected_result = "0";
	do_test(command, expected_result);

	x = 5;
	command = "strp(x);";
	expected_result = "0";
	do_test(command, expected_result);

	y[1] = "bingo";
	command = "strp(y);";
	expected_result = "0";
	do_test(command, expected_result);

	z = "bingo";
	command = "strp(z);";
	expected_result = "1";
	do_test(command, expected_result);

	z = 1;
	command = "strp(z);";
	expected_result = "0";
	do_test(command, expected_result);
}
