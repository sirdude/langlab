#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib "./lib";
use lib "./lib/sweet";
use lib "../lib";
use lib "../lib/sweet";
use lib "../../lib";
use lib "../../lib/sweet";

use ast;
use tests;
use struct_print;

my ($testast, $output, $teststr);

sub test_print_string {
	$testast->add_base_node('keyword', 'print', 0, 20);
	$testast->add_base_node('string', 'Hello World!', 0, 21);
	$testast->add_base_node('op', ';', 0, 22);
	$testast->add_base_node('ident', 'a', 0, 23);

	is(struct_print::start($testast), 1, 'Testing start of print.');
	is(struct_print::get($testast, \%{$output}), 1, 'Testing simple print string;');
	print Dumper(\%{$output});
	is($output, $teststr, 1, 'Testing output of simple print string;');
	is(struct_print::start($testast), 0, 'Testing invalid start of print.');
	is(struct_print::get($testast, \%{$output}), 0, 'Testing get string invalid;');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_print_string();
	return test_summary();
}

main();
