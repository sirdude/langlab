inherit /std/test;

string command, expected_result;

create() {
	string *arr, str;

	arr[0] = "Woo";
	arr[1] = "Hoo";

	# Normal tests
	command = "implode(arr, \":\")";
	expected_result = "Woo:Hoo";
	do_test(command, expected_result);

	command = "implode(arr, \"\")";
	expected_result = "WooHoo";
	do_test(command, expected_result);

	command = "implode(arr, str)";
	expected_result = "WooHoo";
	do_test(command, expected_result);

	arr[0] = "";
	arr[1] = "";

	command = "implode(arr, \":\")";
	expected_result = ":";
	do_test(command, expected_result);

	# XXX Should do some tests with null arr or one element arr
}
