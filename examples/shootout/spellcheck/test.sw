#!/usr/bin/sweet

string command, res;

int main() {
	object exp;
	command = "./spellcheck.sw";

	exp = expect(command);
	exp->send("bingo");

	res = exp->receive();
	if (res != 60) {
		write "Error: $command, expected 60 got " + res + "\n";
	}

	exp->send("bbingo");
	res = exp->receive();
	if (res != 60) {
		write "Error: $command, expected 60 got " + res + "\n";
	}
}

	
