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

my ($testast, $output);

sub test_tok_pound_line_comment_basics {
	$testast->add_node('char', '#', 1, 0);
	$testast->add_node('char', ' ', 2, 0);
	$testast->add_node('char', '9', 3, 0);
	$testast->add_node('char', 'b', 4, 0);
	$testast->add_node('char', '7', 5, 0);
	$testast->add_node('char', '6', 6, 0);
	$testast->add_node('char', ';', 7, 0);
	$testast->add_node('EOL', "\n", 8, 0);
	$testast->add_node('char', 'a', 9, 0);

	is(tok_comment::start($testast), 1, 'Testing if we have the start of a # single line comment.');
	is(tok_comment::get($testast, $output), 1, 'Get # comments.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	is(tok_comment::get($testast, $output), 0, 'Testing if get fails on non comment.');
	$testast->consume(); # Empty our queue so we can run another test.

	return 1;
}

sub test_tok_doubleslash_line_comment_basics {
	$testast->add_node('char', '/', 1, 0);
	$testast->add_node('char', '/', 2, 0);
	$testast->add_node('char', ' ', 3, 0);
	$testast->add_node('char', ' ', 4, 0);
	$testast->add_node('char', '7', 5, 0);
	$testast->add_node('char', '6', 6, 0);
	$testast->add_node('char', ';', 7, 0);
	$testast->add_node('EOL', "\n", 8, 0);
	$testast->add_node('char', 'a', 9, 0);

	is(tok_comment::start($testast), 1, 'Testing if we have the start of a // line comment.');
	is(tok_comment::get($testast, $output), 1, 'Get a // comment.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	$testast->consume(); # Empty our queue so we can run another test.

	return 1;
}

sub test_tok_multi_line_comment_basics {
	$testast->add_node('char', '/', 1, 0);
	$testast->add_node('char', '*', 2, 0);
	$testast->add_node('char', ' ', 3, 0);
	$testast->add_node('char', ' ', 4, 0);
	$testast->add_node('char', '7', 5, 0);
	$testast->add_node('char', '6', 6, 0);
	$testast->add_node('char', ';', 7, 0);
	$testast->add_node('EOL', "\n", 8, 0);
	$testast->add_node('char', 'a', 1, 1);
	$testast->add_node('char', '*', 2, 1);
	$testast->add_node('char', '/', 3, 1);
	$testast->add_node('EOL', "\n", 4, 2);

	is(tok_comment::start($testast), 1, 'Testing if we have the start of a multi line comment.');
	is(tok_comment::get($testast, $output), 1, 'Get a multi comment.');

	is($testast->peek(), "\n", 'Testing to see if we are pointing at the next token.');
	$testast->consume(); # Empty our queue so we can run another test.

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_pound_line_comment_basics();
	test_tok_doubleslash_line_comment_basics();
	test_tok_multi_line_comment_basics();
	test_summary();

	return 1;
}

main();
