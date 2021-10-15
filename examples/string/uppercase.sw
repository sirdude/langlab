inherit /std/test;

string command, expected_result;

create() {
	# Normal tests
	command = "uppercase(\"WooHoo\");";
	expected_result = "woohoo";
	do_test(command, expected_result);

	command = "uppercase(\"woowoo\");";
	expected_result = "woohoo";
	do_test(command, expected_result);

	command = "uppercase(\"\");";
	expected_result = "";
	do_test(command, expected_result);
}
