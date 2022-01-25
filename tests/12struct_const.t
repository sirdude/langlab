#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_const;

my ($testast, $output);

sub test_int {
	$testast->add_base_node('int', '5', 0, 18);
	$testast->add_base_node('op', ';', 0, 19);

	is(struct_const::start($testast), 1, 'Testing start of int');
	is(struct_const::get($testast, $output), 1, 'Testing get int');
	is(struct_const::start($testast), 0, 'Testing invalid start of const');
	is(struct_const::get($testast, $output), 0, 'Testing get const on invalid input');

	$testast->clear();
	return 1;
}

sub test_float {
	$testast->add_base_node('float', '5.001', 0, 31);
	$testast->add_base_node('op', ';', 0, 32);

	is(struct_const::start($testast), 1, 'Testing start of float');
	is(struct_const::get($testast, $output), 1, 'Testing get float');

	$testast->clear();
	return 1;
}

sub test_html {
	$testast->add_base_node('html', '&#0000', 0, 42);
	$testast->add_base_node('op', ';', 0, 43);

	is(struct_const::start($testast), 1, 'Testing start of html');
	is(struct_const::get($testast, $output), 1, 'Testing get html');

	$testast->clear();
	return 1;
}

sub test_hex {
	$testast->add_base_node('hex', 'x0CC', 0, 53);
	$testast->add_base_node('op', ';', 0, 54);

	is(struct_const::start($testast), 1, 'Testing start of hex');
	is(struct_const::get($testast, $output), 1, 'Testing get hex');

	$testast->clear();
	return 1;
}

sub test_string {
	$testast->add_base_node('string', 'hello world', 0, 64);
	$testast->add_base_node('op', ';', 0, 65);

	is(struct_const::start($testast), 1, 'Testing start of string');
	is(struct_const::get($testast, $output), 1, 'Testing get string');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_int();
	test_float();
	test_html();
	test_hex();
	test_string();
	return test_summary();
}

main();
