inherit /std/test;

string command, expected_result;

create() {
	int x, *arrx;
	string y, *arry;
	float a, *arra;
	mixed b, *arrb;

	command = "intp(nil)";
	expected_result = "0";
	do_test(command,expected_result);

	
	command = "intp(x)";
	expected_result = "1";
	do_test(command,expected_result);


	command = "intp(y)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "intp(a)";
	expected_result = "0";
	do_test(command,expected_result);


	command = "intp(b)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "intp(arrx)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "intp(arry)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "intp(arra)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "intp(arrb)";
	expected_result = "0";
	do_test(command,expected_result);
}
