#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "./lib/sweet";
use lib "../lib";
use lib "../lib/sweet";
use lib "../../lib";
use lib "../../lib/sweet";

use ast;
use tests;
use struct_print;

my ($testast, $output);

sub test_print_string {
	$testast->add_base_node('keyword', 'print', 0, 18);
	$testast->add_base_node('string', 'Hello World!', 0, 19);
	$testast->add_base_node('op', ';', 0, 20);
	$testast->add_base_node('ident', 'a', 0, 21);

	is(struct_print::start($testast), 1, 'Testing start of print.');
	is(struct_print::get($testast, $output), 1, 'Testing simple print string;');
	is(struct_print::start($testast), 0, 'Testing invalid start of print.');
	is(struct_print::get($testast, $output), 0, 'Testing get string invalid;');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_print_string();
	return test_summary();
}

main();
