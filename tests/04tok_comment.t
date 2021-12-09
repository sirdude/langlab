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
use tok_comment;

my ($testast);

sub test_tok_singile_line_comment_basics {
	$testast->add_node('char', '#', 1, 0);
	$testast->add_node('char', 'x', 1, 0);
	$testast->add_node('char', '9', 1, 0);
	$testast->add_node('char', '8', 1, 0);
	$testast->add_node('char', '7', 1, 0);
	$testast->add_node('char', '6', 1, 0);
	$testast->add_node('char', ';', 1, 0);
	$testast->add_node('EOL', "\n", 1, 0);
	$testast->add_node('char', 'a', 1, 0);

	print 'Peek: ' . $testast->peek() . "\n";
	print 'Peek: ' . $testast->peek(1) . "\n";
	is(tok_comment::start($testast), 1, 'Testing if we have the start of a single line comment.');
	is(tok_comment::get($testast), 1, 'Testing if we have the start of a single line comment.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	is(tok_comment::get($testast), 0, 'Testing if get fails on non comment.');

	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_singile_line_comment_basics();
	# XXX Need to do more tests on this...
	test_summary();

	return 1;
}

main();
