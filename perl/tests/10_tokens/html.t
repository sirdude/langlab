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
use tok_html;

my ($testast, $output);

sub test_tok_html_basics {
	$testast->add_base_node('char', '&', 0, 20);
	$testast->add_base_node('char', '#', 0, 21);
	$testast->add_base_node('char', '9', 0, 22);
	$testast->add_base_node('char', '8', 0, 23);
	$testast->add_base_node('char', '7', 0, 24);
	$testast->add_base_node('char', '6', 0, 25);
	$testast->add_base_node('char', ';', 0, 26);
	$testast->add_base_node('char', 'a', 0, 27);

	is(tok_html::start($testast), 1, 'Testing if we have the start of a html code.');
	is(tok_html::get($testast, $output), 1, 'Try and get the html.');

	is($testast->peek(), 'a', 'Testing to see if we are pointing at the next token.');
	is(tok_html::get($testast, $output), 0, 'Testing if get fails on non html.');

	$testast->clear();
	return 1;
}

sub test_invalid_html {
	$testast->add_base_node('char', '&', 0, 40);
	$testast->add_base_node('char', '#', 0, 41);
	$testast->add_base_node('char', '9', 0, 42);
	$testast->add_base_node('char', '9', 0, 43);
	$testast->add_base_node('char', '9', 0, 44);
	$testast->add_base_node('char', '9', 0, 45);
	$testast->add_base_node('char', 'a', 0, 46);

	is(tok_html::get($testast, $output), 0, 'Testing if get fails on invalid html.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_html_basics();
	test_invalid_html();
	return test_summary();
}

main();
