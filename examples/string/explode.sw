inherit /std/test;

string command, expected_result;

create() {
	string *arr, str;

	arr[0] = "Woo";
	arr[1] = "Hoo";

	# Normal tests
	command = "explode(\"Woo:Hoo\", \":\")";
	expected_result = arr;
	do_test(command, expected_result);

	command = "explode(WooHoo, \"\")";
	expected_result = "XXX";
	do_test(command, expected_result);

	command = "explode(WooHoo, str)";
	expected_result = "XXX";
	do_test(command, expected_result);

	arr[0] = "";
	arr[1] = "";

	command = "explode(::, \":\")";
	expected_result = "XXX";
	do_test(command, expected_result);

	# XXX Should do some tests with null arr or one element arr
}
