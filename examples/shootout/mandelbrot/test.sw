#!/usr/bin/sweet

int main() {
	string command, res;

	command = "./mandelbrot.sw";
	res = "file:test1.ppm";
	do_test(command, res);

	command = "./mandelbrot.sw 5";
	res = "file:test2.ppm";
	do_test(command, res);
}
