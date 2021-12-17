#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use tok_num;

my ($testast, $output);

sub test_tok_num_basics {
	$testast->add_base_node('char', '0', 1, 0);
	$testast->add_base_node('char', '9', 2, 0);
	$testast->add_base_node('char', '8', 3, 0);
	$testast->add_base_node('char', '7', 4, 0);
	$testast->add_base_node('char', '6', 5, 0);
	$testast->add_base_node('char', ';', 6, 0);

	is(tok_num::start($testast), 1, 'Testing if we have the start of a num.');
	is(tok_num::get($testast, $output), 1, 'Testing if we have the start of a num.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	is(tok_num::get($testast, $output), 0, 'Testing if get fails on non num.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_num_basics();
	test_summary();

	return 1;
}

main();
