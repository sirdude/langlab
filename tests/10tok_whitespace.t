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
use tok_whitespace;

my ($testast, $output);

sub test_tok_whitespace_spaces {
	$testast->add_node('char', ' ', 1, 0);
	$testast->add_node('char', ';', 2, 0);

	is(tok_whitespace::start($testast), 1, 'Testing if we have the start of whitespace.');
	is(tok_whitespace::get($testast, $output), 1, 'Get our whitespace.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	is(tok_whitespace::get($testast, $output), 0, 'Testing if get fails on non whitespace.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.
	$testast->add_node('char', ' ', 1, 0);
	$testast->add_node('char', ' ', 2, 0);
	$testast->add_node('char', ';', 3, 0);
	is(tok_whitespace::get($testast, $output), 1, 'Testing get of multiple whitespaces.');
	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.
	return 1;
}

sub test_tok_whitespace_tab {
	$testast->add_node('char', "\t", 1, 0);
	$testast->add_node('char', ';', 2, 0);

	is(tok_whitespace::start($testast), 1, 'Testing if tab is the start of whitespace.');
	is(tok_whitespace::get($testast, $output), 1, 'Get our tab whitespace.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.

	$testast->add_node('char', "\t", 1, 0);
	$testast->add_node('char', "\t", 2, 0);
	$testast->add_node('char', " ", 2, 0);
	$testast->add_node('char', ';', 3, 0);
	is(tok_whitespace::get($testast, $output), 1, 'Testing get of multiple tabs, with a space.');
	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.
	return 1;
}

sub test_tok_whitespace_eol {
	$testast->add_node('char', "\n", 1, 0);
	$testast->add_node('char', ';', 2, 0);

	is(tok_whitespace::start($testast), 1, 'Testing if newline is the start of whitespace.');
	is(tok_whitespace::get($testast, $output), 1, 'Get our newline whitespace.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.

	$testast->add_node('char', "\t", 1, 0);
	$testast->add_node('char', "\n", 1, 0);
	$testast->add_node('char', ';', 2, 0);

	is(tok_whitespace::get($testast, $output), 1, 'Get tab and newline whitespace.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_whitespace_spaces();
	test_tok_whitespace_tab();
	test_tok_whitespace_eol();
	test_summary();

	return 1;
}

main();
