inherit /std/test;

string command, expected_result;

create() {
	int x, *arrx;
	string y, *arry;
	float a, *arra;
	mixed b, *arrb;

	command = "nilp(nil)";
	expected_result = "1";
	do_test(command,expected_result);

	
	command = "nilp(x)";
	expected_result = "0";
	do_test(command,expected_result);


	command = "nilp(y)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "nilp(a)";
	expected_result = "0";
	do_test(command,expected_result);


	command = "nilp(b)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "nilp(arrx)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "nilp(arry)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "nilp(arra)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "nilp(arrb)";
	expected_result = "0";
	do_test(command,expected_result);
}
