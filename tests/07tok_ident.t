#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use tok_ident;

my ($testast, $output);

sub test_tok_ident_basics {
	$testast->add_node('char', 'i', 1, 0);
	$testast->add_node('char', 'n', 2, 0);
	$testast->add_node('char', 't', 3, 0);

	is(tok_ident::start($testast), 1, 'Testing if we have the start of an ident.');
	is(tok_ident::get($testast, $output), 1, 'Get the ident int.');

	$testast->add_node('char', 'i', 1, 0);
	$testast->add_node('char', 'n', 2, 0);
	$testast->add_node('char', 't', 3, 0);
	$testast->add_node('char', 'a', 4, 0);
	$testast->add_node('char', ';', 5, 0);
	is(tok_ident::get($testast, $output), 1, 'get ident inta.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	is(tok_ident::get($testast, $output), 0, 'Testing if get fails on non ident.');
	$testast->consume(); # get rid of the ';'

	return 1;
}

sub test_ident_with_num {
	$testast->add_node('char', 'i', 1, 0);
	$testast->add_node('char', 'n', 2, 0);
	$testast->add_node('char', 't', 3, 0);
	$testast->add_node('char', '0', 3, 0);
	$testast->add_node('char', '5', 4, 0);
	$testast->add_node('char', ';', 5, 0);

	is(tok_ident::start($testast), 1, 'Testing if we have the start of an ident.');
	is(tok_ident::get($testast, $output), 1, 'Get the ident int05.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	$testast->consume(); # get rid of the ';'

	return 1;
}

sub test_ident_with_underscore {
	$testast->add_node('char', 'i', 1, 0);
	$testast->add_node('char', 'n', 2, 0);
	$testast->add_node('char', 't', 3, 0);
	$testast->add_node('char', '_', 3, 0);
	$testast->add_node('char', '5', 4, 0);
	$testast->add_node('char', ';', 5, 0);

	is(tok_ident::start($testast), 1, 'Testing if we have the start of an ident.');
	is(tok_ident::get($testast, $output), 1, 'Get the ident int_5.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	$testast->consume(); # get rid of the ';'
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_ident_basics();
	test_ident_with_num();
	test_ident_with_underscore();
	test_summary();

	return 1;
}

main();
