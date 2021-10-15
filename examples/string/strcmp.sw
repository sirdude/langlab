inherit /std/test;

string command, expected_result;

create() {
	# Normal tests
	command = "strcmp(\"abcde\", \"abcde\");";
	expected_result = "0";
	do_test(command, expected_result);

	command = "strcmp(\"abcdef\", \"abcde\");";
	expected_result = "1";
	do_test(command, expected_result);

	command = "strcmp(\"abcde\", \"abcdef\");";
	expected_result = "-1";
	do_test(command, expected_result);

	command = "strcmp(\"\", \"abcdef\");";
	expected_result = "-1";
	do_test(command, expected_result);

	command = "strcmp(\"abcdef\", \"\");";
	expected_result = "1";
	do_test(command, expected_result);
}
