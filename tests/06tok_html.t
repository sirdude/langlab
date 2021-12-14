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
use tok_html;

my ($testast, $output);

sub test_tok_html_basics {
	$testast->add_node('char', '&', 1, 0);
	$testast->add_node('char', '#', 2, 0);
	$testast->add_node('char', '9', 3, 0);
	$testast->add_node('char', '8', 4, 0);
	$testast->add_node('char', '7', 5, 0);
	$testast->add_node('char', '6', 6, 0);
	$testast->add_node('char', ';', 7, 0);
	$testast->add_node('char', 'a', 8, 0);

	is(tok_html::start($testast), 1, 'Testing if we have the start of a html code.');
	is(tok_html::get($testast, $output), 1, 'Try and get the html.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	is(tok_html::get($testast, $output), 0, 'Testing if get fails on non html.');

	$testast->consume(); # get rid of the 'a' so we can put something that looks like html in the queue.
	$testast->add_node('char', '&', 1, 0);
	$testast->add_node('char', '#', 2, 0);
	$testast->add_node('char', '9', 3, 0);
	$testast->add_node('char', '9', 4, 0);
	$testast->add_node('char', '9', 5, 0);
	$testast->add_node('char', '9', 6, 0);
	$testast->add_node('char', 'a', 7, 0);

	is(tok_html::get($testast, $output), 0, 'Testing if get fails on invalid html.');

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_html_basics();
	test_summary();

	return 1;
}

main();
