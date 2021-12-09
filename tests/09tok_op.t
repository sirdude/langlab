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
use tok_op;

my ($testast);

sub test_tok_op_basics {
	$testast->add_node('char', '=', 1, 0);
	$testast->add_node('char', '=', 2, 0);
	$testast->add_node('char', 'a', 3, 0);


	print 'Peek: ' . $testast->peek() . "\n";
	print 'Peek: ' . $testast->peek(1) . "\n";
	is(tok_op::start($testast), 1, 'Testing if we have the start of a operator.');
	is(tok_op::get($testast), 1, 'Testing if we have the start of a operator.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	is(tok_op::get($testast), 0, 'Testing if get fails on non op.');

	$testast->consume(); # get rid of the 'a' so we can put something that looks like a hex in the queue.

	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_op_basics();
	test_summary();

	return 1;
}

main();