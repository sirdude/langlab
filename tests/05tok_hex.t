#!/usr/bin/perl

use strict;
use warnings;
# use Test::More tests => 9;
# use Test::Exception;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use tok_hex;

my ($testast);

sub test_tok_hex_basics {
	$testast->add_node('char', '0', 1, 0);
	$testast->add_node('char', 'x', 2, 0);
	$testast->add_node('char', '9', 3, 0);
	$testast->add_node('char', '8', 4, 0);
	$testast->add_node('char', '7', 5, 0);
	$testast->add_node('char', '6', 6, 0);
	$testast->add_node('char', ';', 7, 0);

	print 'Peek: ' . $testast->peek() . "\n";
	print 'Peek: ' . $testast->peek(1) . "\n";
	is(tok_hex::start($testast), 1, 'Testing if we have the start of a hex num.');
	is(tok_hex::get($testast), 1, 'Testing if we have the start of a hex num.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	is(tok_hex::get($testast), 0, 'Testing if get fails on non hex.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.
	$testast->add_node('char', '0', 1, 0);
	$testast->add_node('char', 'x', 2, 0);
	$testast->add_node('char', '9', 3, 0);
	$testast->add_node('char', ';', 4, 0);
	is(tok_hex::get($testast), 0, 'Testing if get fails on invalid hex.');

	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_hex_basics();
	test_summary();

	return 1;
}

main();
