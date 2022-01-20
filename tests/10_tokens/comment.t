#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use tok_comment;

my ($testast, $output);

sub test_tok_pound_line_comment_basics {
	$testast->add_base_node('char', '#', 18, 0);
	$testast->add_base_node('char', ' ', 19, 0);
	$testast->add_base_node('char', '9', 20, 0);
	$testast->add_base_node('char', 'b', 21, 0);
	$testast->add_base_node('char', '7', 22, 0);
	$testast->add_base_node('char', '6', 23, 0);
	$testast->add_base_node('char', ';', 24, 0);
	$testast->add_base_node('EOL', "\n", 25, 0);
	$testast->add_base_node('char', 'a', 26, 0);

	is(tok_comment::start($testast), 1, 'Testing if we have the start of a # single line comment.');
	is(tok_comment::get($testast, $output), 1, 'Get # comments.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	is(tok_comment::get($testast, $output), 0, 'Testing if get fails on non comment.');

	$testast->clear();
	return 1;
}

sub test_tok_doubleslash_line_comment_basics {
	$testast->add_base_node('char', '/', 39, 0);
	$testast->add_base_node('char', '/', 40, 0);
	$testast->add_base_node('char', ' ', 41, 0);
	$testast->add_base_node('char', ' ', 42, 0);
	$testast->add_base_node('char', '7', 43, 0);
	$testast->add_base_node('char', '6', 44, 0);
	$testast->add_base_node('char', ';', 45, 0);
	$testast->add_base_node('EOL', "\n", 46, 0);
	$testast->add_base_node('char', 'a', 47, 0);

	is(tok_comment::start($testast), 1, 'Testing if we have the start of a // line comment.');
	is(tok_comment::get($testast, $output), 1, 'Get a // comment.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	$testast->consume(); # Empty our queue so we can run another test.

	return 1;
}

sub test_tok_multi_line_comment_basics {
	$testast->add_base_node('char', '/', 59, 0);
	$testast->add_base_node('char', '*', 60, 0);
	$testast->add_base_node('char', ' ', 61, 0);
	$testast->add_base_node('char', ' ', 62, 0);
	$testast->add_base_node('char', '7', 63, 0);
	$testast->add_base_node('char', '6', 64, 0);
	$testast->add_base_node('char', ';', 65, 0);
	$testast->add_base_node('EOL', "\n", 66, 0);
	$testast->add_base_node('char', 'a', 67, 1);
	$testast->add_base_node('char', '*', 68, 1);
	$testast->add_base_node('char', '/', 69, 1);
	$testast->add_base_node('char', 'a', 70, 2);

	is(tok_comment::start($testast), 1, 'Testing if we have the start of a multi line comment.');
	is(tok_comment::get($testast, $output), 1, 'Get a multi comment.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token a.');
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
	return test_summary();
}

main();
