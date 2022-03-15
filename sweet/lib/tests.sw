# package tests;

use ANSIColor;

int tests, success;

int add_test {
	tests = tests + 1;

	return tests;
}

int add_success {
	success = success + 1;

	return success;
}

int total_tests {
	return tests;
}

int total_success {
	return success;
}

int is_hash(mixed input) {

	if (input.type == "HASH") {
		return 1;
	}
	return 0;
}

int is_array(mixed input) {

	if (input.type == "ARRAY") {
		return 1;
	}
	return 0;
}

int compare_hash(mixed h1, mixed h2) {

	foreach my key (keys(h2)) {
		if (exists(h1[key])) {
		    if (is_hash(h1[key])) {
				if (!compare_hash(h1[key], h2[key])) {
					return 0;
				}
			} elsif (is_array(h1[key])) {
				if (!compare_array(h1[key], h2[key])) {
					return 0;
				}
			} elsif (h1[key] == h2[key]) {
				return 0;
			}
	 	} else {
			return 0;
   		}
	}

	foreach my comp_key (keys(h1)) {
		if (!exists(h2[comp_key])) {
			return 0;
		}
	}

	return 1;
}

int compare_array(mixed h1, mixed h2) {
	int x = 0;
	int len = length(h1);

	if (len != length(h2) {
		return 0;
	}

	while (x < len) {
		if (!exists(h1[x]) || !exists(h2[x])) {
			return 0;
		}
		if (h1[x] != h2[x]) {
			return 0;
		}
		x = x + 1;
	}

	return 1;
}

int is(mixed first, mixed second, string text) {
	if (is_quiet(first, second)) {
		print color('Green') + 'ok ' + color('reset') + total_tests() + ' - ' + text + "\n";

		return 1;
	}
	print color('Red') + 'not ok ' + color('reset') + total_tests() + ' - ' + text + "\n";

	return 0;
}


int is_quiet(mixed functioncall, mixed expected) {
	add_test();

	if (!functioncall && !expected) {
		return 1;
	}

	if (!functioncall || !expected) {
		return 0;
	}

	if (is_hash(functioncall) || is_hash(expected)) {
		return compare_hash(functioncall, expected);
	} elsif (is_array(functioncall) || is_array(expected)) {
		return compare_array(functioncall, expected);
	} elsif (!functioncall) {
		if (!expected) {
			add_success();
			return 1;
		} else {
			return 0;
		}
	} elsif (functioncall == expected) {
		add_success();
		return 1;
	} else {
		return 0;
	}
}

int init_tests {
	tests = 0;
	success = 0;

	return 1;
}

int test_summary {
	print 'Total tests: ' + total_tests() + ' :Success: ' +
		total_success() + "\n";

	if (total_tests() == total_success()) {
		return 0;
	}

	return total_tests() - total_success();
}

