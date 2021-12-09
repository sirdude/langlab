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
use tok_ident;

my ($testast);

sub test_tok_ident_basics {
	$testast->add_node('char', 'i', 1, 0);
	$testast->add_node('char', 'n', 1, 0);
	$testast->add_node('char', 't', 1, 0);

	is(tok_ident::start($testast), 1, 'Testing if we have the start of an ident.');
	is(tok_hex::get($testast), 1, 'Get the ident int.');

	$testast->add_node('char', 'i', 1, 0);
	$testast->add_node('char', 'n', 1, 0);
	$testast->add_node('char', 't', 1, 0);
	$testast->add_node('char', 'a', 1, 0);
	$testast->add_node('char', ';', 1, 0);
	is(tok_hex::get($testast), 1, 'get ident inta.');

	is($testast->peek(), ';', 'Testing to see if we are pointing at the next token.');
	is(tok_hex::get($testast), 0, 'Testing if get fails on non ident.');

	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_tok_ident_basics();
	test_summary();

	return 1;
}

main();
