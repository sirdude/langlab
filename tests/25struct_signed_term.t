#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_signed_term;

my ($testast, $output);

sub test_plus_term {
	$testast->add_base_node('op', '+', 0, 18);
	$testast->add_base_node('int', '5', 0, 18);
	$testast->add_base_node('op', ';', 0, 18);

	is(struct_signed_term::start($testast), 1, 'Testing start of signed_term with +5;.');
	is(struct_signed_term::get($testast, $output), 1, 'Testing get signed_term: +5;');
	is(struct_signed_term::start($testast), 0, 'Testing start of signed_term invalid.');

	$testast->clear();
	return 1;
}

sub test_minus_term {
	$testast->add_base_node('op', '-', 0, 28);
	$testast->add_base_node('int', '5', 0, 28);
	$testast->add_base_node('op', ';', 0, 29);

	is(struct_signed_term::start($testast), 1, 'Testing start of signed_term with -5;.');
	is(struct_signed_term::get($testast, $output), 1, 'Testing get signed_term with -5;.');

	$testast->clear();
	return 1;
}

sub test_basic_term {
	$testast->add_base_node('int', '5', 0, 28);
	$testast->add_base_node('op', ';', 0, 29);

	is(struct_signed_term::start($testast), 1, 'Testing start of signed_term with 5;.');
	is(struct_signed_term::get($testast, $output), 1, 'Testing get signed_term with 5;.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_plus_term();
	test_minus_term();
	test_basic_term();
	return test_summary();
}

main();
