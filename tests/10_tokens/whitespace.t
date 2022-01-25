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
use tok_whitespace;

my ($testast, $output);

sub test_tok_whitespace_spaces {
	$testast->add_base_node('char', ' ', 0, 18);
	$testast->add_base_node('char', ';', 0, 19);

	is(tok_whitespace::start($testast), 1, 'Testing if we have the start of whitespace.');
	is(tok_whitespace::get($testast, $output), 1, 'Get our whitespace.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	is(tok_whitespace::get($testast, $output), 0, 'Testing if get fails on non whitespace.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.
	$testast->add_base_node('char', ' ', 0, 28);
	$testast->add_base_node('char', ' ', 0, 29);
	$testast->add_base_node('char', ';', 0, 30);
	is(tok_whitespace::get($testast, $output), 1, 'Testing get of multiple white spaces.');
	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');

	$testast->clear();
	return 1;
}

sub test_tok_whitespace_tab {
	$testast->add_base_node('char', "\t", 0, 39);
	$testast->add_base_node('char', ';', 0, 40);

	is(tok_whitespace::start($testast), 1, 'Testing if tab is the start of whitespace.');
	is(tok_whitespace::get($testast, $output), 1, 'Get our tab whitespace.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.

	$testast->add_base_node('char', "\t", 0, 49);
	$testast->add_base_node('char', "\t", 0, 50);
	$testast->add_base_node('char', ' ', 0, 51);
	$testast->add_base_node('char', ';', 0, 52);
	is(tok_whitespace::get($testast, $output), 1, 'Testing get of multiple tabs, with a space.');
	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');

	$testast->clear();
	return 1;
}

sub test_tok_whitespace_eol {
	$testast->add_base_node('char', "\n", 0, 61);
	$testast->add_base_node('char', ';', 0, 62);

	is(tok_whitespace::start($testast), 1, 'Testing if newline is the start of whitespace.');
	is(tok_whitespace::get($testast, $output), 1, 'Get our newline whitespace.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');

	$testast->consume(); # get rid of the ';' so we can put something that looks like a hex in the queue.

	$testast->add_base_node('char', "\t", 0, 71);
	$testast->add_base_node('char', "\n", 0, 72);
	$testast->add_base_node('char', ';', 0, 73);

	is(tok_whitespace::get($testast, $output), 1, 'Get tab and newline whitespace.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');

	$testast->clear();
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
	return test_summary();
}

main();
