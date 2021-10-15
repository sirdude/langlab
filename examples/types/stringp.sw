inherit /std/test;

string command, expected_result;

create() {
	int x, *arrx;
	string y, *arry;
	float a, *arra;
	mixed b, *arrb;

	command = "stringp(nil)";
	expected_result = "0";
	do_test(command,expected_result);

	
	command = "stringp(x)";
	expected_result = "0";
	do_test(command,expected_result);


	command = "stringp(y)";
	expected_result = "1";
	do_test(command,expected_result);

	command = "stringp(a)";
	expected_result = "0";
	do_test(command,expected_result);


	command = "stringp(b)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "stringp(arrx)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "stringp(arry)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "stringp(arra)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "stringp(arrb)";
	expected_result = "0";
	do_test(command,expected_result);
}
