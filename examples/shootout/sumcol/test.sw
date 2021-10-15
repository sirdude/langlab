#!/usr/bin/sweet

string command, res;

int main() {
	object exp;
	command = "./sumcol.sw";

	exp = expect(command);
	exp->send(30);
	exp->send(30);

	res = exp->receive();
	if (res != 60) {
		write "Error: $command, expected 60 got " + res + "\n";
	}
}

	
