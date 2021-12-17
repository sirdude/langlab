#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";

use symbol_table;
use tests;

my ($testast);

sub test_sym_table {
	is($testast->insert_symbol('x','int',5), 1, 'Insert symbol x.');
	is($testast->intable('x'), 1, 'Is x in our table?');
	is($testast->intable('y'), 0, 'Is y in our table?');
	is($testast->lookup_value('x'), 5, 'Get the value of x.');
	is($testast->lookup_value('y'), 0, 'Get the value of y.');
	is($testast->lookup_type('x'), 'int', 'Get the value of x.');
	is($testast->lookup_type('y'), '', 'Get the value of y.');

	return 1;
}

sub main {
	$testast = symbol_table->new();
	init_tests();
	test_sym_table();
	return test_summary();
}

main();
