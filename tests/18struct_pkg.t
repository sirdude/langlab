#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_pkg;

my ($testast, $output);

sub test_use_pkg {
	$testast->add_base_node('keyword', "use", 1, 0);
	$testast->add_base_node('options', "x", 1, 2);
	$testast->add_base_node('op', ";", 1, 3);
	is(struct_pkg::start($testast), 1, 'Testing start of use.');
	is(struct_pkg::get($testast, $output), 1, 'Testing use options;');

	return 1;
}

sub test_use_lib {
	$testast->add_base_node('keyword', "use", 1, 0);
	$testast->add_base_node('options', "lib", 1, 2);
	$testast->add_base_node('options', "./", 1, 2);
	$testast->add_base_node('op', ";", 1, 3);

	is(struct_pkg::start($testast), 1, 'Testing if we have the start of a function def.');
	is(struct_pkg::get($testast, $output), 1, 'Testing void main() {}.');
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_use_pkg();
	test_use_lib();
	return test_summary();
}

main();
