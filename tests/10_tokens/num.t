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
use tok_num;

my ($testast, $output);

sub test_tok_num_basics {
	$testast->add_base_node('char', '0', 0, 20);
	$testast->add_base_node('char', '9', 0, 21);
	$testast->add_base_node('char', '8', 0, 22);
	$testast->add_base_node('char', '7', 0, 23);
	$testast->add_base_node('char', '6', 0, 24);
	$testast->add_base_node('char', ';', 0, 25);

	is(tok_num::start($testast), 1, 'Testing if we have the start of a num.');
	is(tok_num::get($testast, $output), 1, 'Testing if we have the start of a num.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	is(tok_num::get($testast, $output), 0, 'Testing if get fails on non num.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_num_basics();
	return test_summary();
}

main();
