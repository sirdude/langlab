inherit /std/test;

string command, expected_result;

create() {
	# Normal tests
	command = "lowercase(\"WooHoo\");";
	expected_result = "woohoo";
	do_test(command, expected_result);

	command = "lowercase(\"woowoo\");";
	expected_result = "woohoo";
	do_test(command, expected_result);

	command = "lowercase(\"\");";
	expected_result = "";
	do_test(command, expected_result);
}
