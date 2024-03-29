#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib "./lib";
use lib "./lib/sweet";
use lib "../lib";
use lib "../lib/sweet";
use lib "../../lib";
use lib "../../lib/sweet";

use ast;
use tests;
use struct_if;

my ($testast, $output);

sub test_simple_if {
	my %teststr = (
		'data' => {
			'type' => 'expression'
		},
		'ifcase' => {
			'linenum' => 24,
			'data' => undef,
			'columnnum' => 0,
			'type' => 'block'
		},
		'type' => 'if'
	);

	$testast->add_base_node('keyword', 'if', 0, 20);
	$testast->add_base_node('op', '(', 0, 21);
	$testast->add_base_node('int', '1', 0, 22);
	$testast->add_base_node('op', ')', 0, 23);
	$testast->add_base_node('op', '{', 0, 24);
	$testast->add_base_node('op', '}', 0, 25);
	$testast->add_base_node('op', ';', 0, 26);

	is(struct_if::start($testast), 1, 'Testing start of if statement.');
	is(struct_if::get($testast, \%{$output}), 1, 'Testing if (1) {};');

	# print Dumper(\%{$output});
	is(compare_hash(\%{$output}, \%teststr), 1, 'Testing output of get if (1) {}');

	is(struct_if::start($testast), 0, 'Testing start of if statement with ;.');
	is(struct_if::get($testast, \%{$output}), 0, 'Testing get on invalid if');

	$testast->clear();
	return 1;
}

sub test_if_else() {
	my %teststr = (
		'data' => {
			'type' => 'expression'
		},
		'elsecase' => {
			'type' => 'block',
			'columnnum' => 0,
			'linenum' => 45,
			'data' => undef
		},
		'type' => 'if',
		'ifcase' => {
			'type' => 'block',
			'data' => undef,
			'linenum' => 42,
			'columnnum' => 0
		}
	);

	$testast->add_base_node('keyword', 'if', 0, 38);
	$testast->add_base_node('op', '(', 0, 39);
	$testast->add_base_node('ident', 'x', 0, 40);
	$testast->add_base_node('op', ')', 0, 41);
	$testast->add_base_node('op', '{', 0, 42);
	$testast->add_base_node('op', '}', 0, 43);
	$testast->add_base_node('keyword', 'else', 0, 44);
	$testast->add_base_node('op', '{', 0, 45);
	$testast->add_base_node('op', '}', 0, 46);
	$testast->add_base_node('op', ';', 0, 47);

	is(struct_if::get($testast, \%{$output}), 1, 'Testing if else');

	# print Dumper(\%{$output});
	is(compare_hash(\%{$output}, \%teststr), 1, 'Testing output of get if else');

	$testast->clear();
	return 1;
}

sub test_if_else_noblock() {
	$testast->add_base_node('keyword', 'if', 0, 56);
	$testast->add_base_node('op', '(', 0, 57);
	$testast->add_base_node('ident', 'x', 0, 58);
	$testast->add_base_node('op', ')', 0, 59);
	$testast->add_base_node('op', '{', 0, 60);
	$testast->add_base_node('op', '}', 0, 61);
	$testast->add_base_node('keyword', 'else', 0, 62);
	$testast->add_base_node('ident', 'x', 0, 63);
	$testast->add_base_node('op', ';', 0, 64);

	is(struct_if::get($testast, \%{$output}), 0, 'Testing if else noblock');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_simple_if();
	test_if_else();
	test_if_else_noblock();
	return test_summary();
}

main();
