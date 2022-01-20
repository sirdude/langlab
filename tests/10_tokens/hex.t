#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use tok_hex;

my ($testast, $output);

sub test_tok_hex_basics {
	$testast->add_base_node('char', '0', 0, 18);
	$testast->add_base_node('char', 'x', 0, 19);
	$testast->add_base_node('char', '9', 0, 20);
	$testast->add_base_node('char', '8', 0, 21);
	$testast->add_base_node('char', '7', 0, 22);
	$testast->add_base_node('char', '6', 0, 23);
	$testast->add_base_node('char', ';', 0, 24);

	is(tok_hex::start($testast), 1, 'Testing if we have the start of a hex number.');
	is(tok_hex::get($testast, $output), 1, 'Testing get a hex number.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	is(tok_hex::get($testast, $output), 0, 'Testing if get fails on non hex number.');

	$testast->clear();
	return 1;
}

sub test_invalid_hex {
	$testast->add_base_node('char', '0', 0, 37);
	$testast->add_base_node('char', 'x', 0, 38);
	$testast->add_base_node('char', ';', 0, 39);
	is(tok_hex::get($testast, $output), 0, 'Testing if get fails on invalid hex.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_hex_basics();
	test_invalid_hex();
	return test_summary();
}

main();
