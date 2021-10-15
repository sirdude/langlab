inherit /std/test;

string command, expected_result;

create() {
	int x, *arrx;
	string y, *arry;
	float a, *arra;
	mixed b, *arrb;
	mapping	map, *maparr;
	object obj, *objarr;

	command = "objectp(nil)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "objectp(void)";
	expected_result = "0";
	do_test(command,expected_result);
	
	command = "objectp(x)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "objectp(y)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "objectp(a)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "objectp(b)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "objectp(obj)";
	expected_result = "0";
	do_test(command,expected_result);

	obj = this_object();
	command = "objectp(obj)";
	expected_result = "1";
	do_test(command,expected_result);

	obj = load_object("/std/object.sw");
	command = "objectp(obj)";
	expected_result = "1";
	do_test(command,expected_result);

	command = "objectp(map)";
	expected_result = "1";
	do_test(command,expected_result);

	map = ({ });
	command = "objectp(map)";
	expected_result = "1";
	do_test(command,expected_result);

	map{ x } = 5;
	command = "objectp(map)";
	expected_result = "1";
	do_test(command,expected_result);

	command = "objectp(arrx)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "objectp(arry)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "objectp(arra)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "objectp(arrb)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "objectp(maparr)";
	expected_result = "0";
	do_test(command,expected_result);

	command = "objectp(objarr)";
	expected_result = "0";
	do_test(command,expected_result);
}
