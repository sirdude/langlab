inherit /std/test;

string command, expected_result;

create() {
	# Normal tests
	command = "strstr(\"abcdef abcdef ghij\", \"abcde\");";
	expected_result = "0";
	do_test(command, expected_result);

	command = "strstr(\"abcdef abcdef ghij\", \"bcde\");";
	expected_result = "1";
	do_test(command, expected_result);

	# Outside cases
	command = "strstr(\"abcdef abcdef ghij\", \"zzz\");";
	expected_result = "-1";
	do_test(command, expected_result);

	command = "strstr(\"", \"zzz\");";
	expected_result = "-1";
	do_test(command, expected_result);

	command = "strstr(\"abcdef abcdef ghij\", \"\");";
	expected_result = "-1";
	do_test(command, expected_result);
}
