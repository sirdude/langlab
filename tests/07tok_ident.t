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
	$testast->add_base_node('char', 'i', 0, 18);
	$testast->add_base_node('char', 'n', 0, 19);
	$testast->add_base_node('char', 't', 0, 20);

	is(tok_ident::start($testast), 1, 'Testing if we have the start of an ident.');
	is(tok_ident::get($testast, $output), 1, 'Get the ident int.');

	$testast->add_base_node('char', 'i', 0, 25);
	$testast->add_base_node('char', 'n', 0, 26);
	$testast->add_base_node('char', 't', 0, 27);
	$testast->add_base_node('char', 'a', 0, 28);
	$testast->add_base_node('char', ';', 0, 29);
	is(tok_ident::get($testast, $output), 1, 'get ident inta.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	is(tok_ident::get($testast, $output), 0, 'Testing if get fails on non ident.');
	$testast->consume(); # get rid of the ';'

	return 1;
}

sub test_ident_with_num {
	$testast->add_base_node('char', 'i', 0, 40);
	$testast->add_base_node('char', 'n', 0, 41);
	$testast->add_base_node('char', 't', 0, 42);
	$testast->add_base_node('char', '0', 0, 43);
	$testast->add_base_node('char', '5', 0, 44);
	$testast->add_base_node('char', ';', 0, 45);

	is(tok_ident::start($testast), 1, 'Testing if we have the start of an ident.');
	is(tok_ident::get($testast, $output), 1, 'Get the ident int05.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	$testast->consume(); # get rid of the ';'

	return 1;
}

sub test_ident_with_underscore {
	$testast->add_base_node('char', 'i', 0, 57);
	$testast->add_base_node('char', 'n', 0, 58);
	$testast->add_base_node('char', 't', 0, 59);
	$testast->add_base_node('char', '_', 0, 60);
	$testast->add_base_node('char', '5', 0, 61);
	$testast->add_base_node('char', ';', 0, 62);

	is(tok_ident::start($testast), 1, 'Testing if we have the start of an ident.');
	is(tok_ident::get($testast, $output), 1, 'Get the ident int_5.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	$testast->consume(); # get rid of the ';'
	return 1;
}

sub test_keyword {
	is(tok_ident::is_keyword('if'), 1, 'Testing if if is a keyword.');
	is(tok_ident::is_keyword('ifnot'), 0, 'Testing if ifnot is a keyword.');

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
	test_keyword();
	return test_summary();
}

main();
