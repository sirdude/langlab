string key;
string type;
mixed value;
object prev, next;

int set_key(string input) {
	key = input;
	return 1;
}

string query_key() {
	return key;
}

int set_type(string input) {
	/* already checked for valid type */
	type = input;
	return 1;
}

string query_type() {
	return type;
}

int set_value(mixed input) {
	value = input;
	return 1;
}

mixed query_value() {
	return value;
}

int set_next(object input) {
	next = input;
}

int set_prev(object input) {
	prev = input;
}

object query_prev() {
	return prev;
}

int main() {
}
