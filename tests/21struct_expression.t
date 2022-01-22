#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_expression;

my ($testast, $output);
my @binops = ('||', '&&', '==', '!=', '+=', '-=', '>=', '<=', '>', '<',
	'+', '=,', '*', '/');
my @unops = ('+', '-');

sub test_const_expression {
	$testast->add_base_node('int', '1', 0, 18);
	$testast->add_base_node('op', ';', 0, 19);

	is(struct_expression::start($testast), 1, 'Testing start of constant expression 1.');
	is(struct_expression::get($testast, $output), 1, 'Testing expression: 1;');

	$testast->clear();
	return 1;
}

sub test_binops {
	foreach my $i (@binops) {
		$testast->add_base_node('ident', 'x', 0, 29);
		$testast->add_base_node('op', $i, 0, 30);
		$testast->add_base_node('int', '5', 0, 31);
		$testast->add_base_node('op', ';', 0, 32);

		is(struct_expression::get($testast, $output), 1, 'Testing expression binop: ' . $i );

		$testast->clear();
	}
	return 1;
}

sub test_unops {
	foreach my $i (@unops) {
		$testast->add_base_node('op', $i, 0, 30);
		$testast->add_base_node('int', '5', 0, 31);
		$testast->add_base_node('op', ';', 0, 32);

		is(struct_expression::get($testast, $output), 1, 'Testing expression unop: ' . $i );

		$testast->clear();
	}
	return 1;
}

sub test_var_equals {
	$testast->add_base_node('ident', 'x', 0, 29);
	$testast->add_base_node('op', '==', 0, 30);
	$testast->add_base_node('int', '5', 0, 31);
	$testast->add_base_node('op', ';', 0, 32);

	is(struct_expression::start($testast), 1, 'Testing start of expression x==5.');
	is(struct_expression::get($testast, $output), 1, 'Testing expression x==5.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_const_expression();
	test_binops();
	test_unops();
	return test_summary();
}

main();
