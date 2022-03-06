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
use tok_op;

my ($testast, $output);

sub test_tok_op_equal {
	$testast->add_base_node('char', '=', 0, 19);
	$testast->add_base_node('char', 'a', 0, 20);

	is(tok_op::start($testast), 1, 'Testing if we have the start of a operator.');
	is(tok_op::get($testast, $output), 1, 'Testing get =.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');

	is(tok_op::get($testast, $output), 0, 'Testing if get fails on non op.');

	$testast->clear();
	return 1;
}

sub test_tok_op_equalequal {
	$testast->add_base_node('char', '=', 0, 35);
	$testast->add_base_node('char', '=', 0, 36);
	$testast->add_base_node('char', 'a', 0, 37);

	is(tok_op::start($testast), 1, 'Testing if we have the start of a operator.');
	is(tok_op::get($testast, $output), 1, 'Testing get ==.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	$testast->clear();
	return 1;
}

sub test_tok_op_nottwoops {
	$testast->add_base_node('char', '.', 0, 48);
	$testast->add_base_node('char', ';', 0, 49);
	$testast->add_base_node('char', 'a', 0, 50);

	is(tok_op::start($testast), 1, 'Testing if we have the start of a operator.');
	is(tok_op::get($testast, $output), 1, 'Testing get ".".');
	is(tok_op::get($testast, $output), 1, 'Testing get ";".');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_op_equal();
	test_tok_op_equalequal();
	test_tok_op_nottwoops();
	return test_summary();
}

main();
