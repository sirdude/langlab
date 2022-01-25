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
use tok_comment;

my ($testast, $output);

sub test_tok_pound_line_comment_basics {
	$testast->add_base_node('char', '#', 20, 0);
	$testast->add_base_node('char', ' ', 21, 0);
	$testast->add_base_node('char', '9', 22, 0);
	$testast->add_base_node('char', 'b', 23, 0);
	$testast->add_base_node('char', '7', 24, 0);
	$testast->add_base_node('char', '6', 25, 0);
	$testast->add_base_node('char', ';', 26, 0);
	$testast->add_base_node('EOL', "\n", 27, 0);
	$testast->add_base_node('char', 'a', 28, 0);

	is(tok_comment::start($testast), 1, 'Testing if we have the start of a # single line comment.');
	is(tok_comment::get($testast, $output), 1, 'Get # comments.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	is(tok_comment::get($testast, $output), 0, 'Testing if get fails on non comment.');

	$testast->clear();
	return 1;
}

sub test_tok_doubleslash_line_comment_basics {
	$testast->add_base_node('char', '/', 41, 0);
	$testast->add_base_node('char', '/', 42, 0);
	$testast->add_base_node('char', ' ', 43, 0);
	$testast->add_base_node('char', ' ', 44, 0);
	$testast->add_base_node('char', '7', 45, 0);
	$testast->add_base_node('char', '6', 46, 0);
	$testast->add_base_node('char', ';', 47, 0);
	$testast->add_base_node('EOL', "\n", 48, 0);
	$testast->add_base_node('char', 'a', 49, 0);

	is(tok_comment::start($testast), 1, 'Testing if we have the start of a // line comment.');
	is(tok_comment::get($testast, $output), 1, 'Get a // comment.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	$testast->consume(); # Empty our queue so we can run another test.

	return 1;
}

sub test_tok_multi_line_comment_basics {
	$testast->add_base_node('char', '/', 61, 0);
	$testast->add_base_node('char', '*', 62, 0);
	$testast->add_base_node('char', ' ', 63, 0);
	$testast->add_base_node('char', ' ', 64, 0);
	$testast->add_base_node('char', '7', 65, 0);
	$testast->add_base_node('char', '6', 66, 0);
	$testast->add_base_node('char', ';', 67, 0);
	$testast->add_base_node('EOL', "\n", 68, 0);
	$testast->add_base_node('char', 'a', 69, 1);
	$testast->add_base_node('char', '*', 70, 1);
	$testast->add_base_node('char', '/', 71, 1);
	$testast->add_base_node('char', 'a', 72, 2);

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
