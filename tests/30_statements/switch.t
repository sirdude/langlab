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
use struct_switch;

my ($testast, $output);

sub test_nodefault_switch {
	my %teststr = {
	};

	$testast->add_base_node('keyword', 'switch', 0, 18);
	$testast->add_base_node('ident', 'x', 0, 19);
	$testast->add_base_node('op', '{', 0, 20);
	$testast->add_base_node('keyword', 'case', 0, 21);
	$testast->add_base_node('int', '1', 0, 22);
	$testast->add_base_node('op', '{', 0, 23);
	$testast->add_base_node('op', '}', 0, 24);
	$testast->add_base_node('op', '}', 0, 25);
	$testast->add_base_node('op', ';', 0, 26);

	is(struct_switch::start($testast), 1, 'Testing start of switch statement.');
	is(struct_switch::get($testast, \%{$output}), 1, 'Testing switch with no default');

	print Dumper(\%{$output});
	is(compare_hash(\%{$output}, %teststr), 1, 'Testing output of switch with no default');

	is(struct_switch::start($testast), 0, 'Testing start of switch with ;.');

	$testast->clear();
	return 1;
}

sub test_nocase_switch {
	my %teststr = {
		'variable' => 'switch',
		'data' => {},
		'type' => 'switch',
		'default' => '{}'
	};

	$testast->add_base_node('keyword', 'switch', 0, 39);
	$testast->add_base_node('ident', 'x', 0, 40);
	$testast->add_base_node('op', '{', 0, 41);
	$testast->add_base_node('keyword', 'default', 0, 42);
	$testast->add_base_node('op', '{', 0, 43);
	$testast->add_base_node('op', '}', 0, 44);
	$testast->add_base_node('op', '}', 0, 45);
	$testast->add_base_node('op', ';', 0, 46);

	is(struct_switch::get($testast, \%{$output}), 1, 'Testing nocase switch');

	print Dumper(\%{$output});
	is(compare_hash(\%{$output}, %teststr), 1, 'Testing output of nocase switch');

	$testast->clear();
	return 1;
}

sub test_simple_switch {
	my %teststr = {
		'data' => {},
		'type' => 'switch',
		'default' => {},
		'variable' => 'x'
	};

	$testast->add_base_node('keyword', 'switch', 0, 55);
	$testast->add_base_node('ident', 'x', 0, 56);
	$testast->add_base_node('op', '{', 0, 57);
	$testast->add_base_node('int', '5', 0, 58);
	$testast->add_base_node('op', '{', 0, 59);
	$testast->add_base_node('op', '}', 0, 60);
	$testast->add_base_node('keyword', 'default', 0, 61);
	$testast->add_base_node('op', '{', 0, 62);
	$testast->add_base_node('op', '}', 0, 63);
	$testast->add_base_node('op', '}', 0, 64);
	$testast->add_base_node('op', ';', 0, 65);

	is(struct_switch::get($testast, \%{$output}), 1, 'Testing simple switch');

	print Dumper(\%{$output});
	is(compare_hash(\%{$output}, %teststr), 1, 'Testing output of simple switch');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_nodefault_switch();
	test_nocase_switch();
	test_simple_switch();
	return test_summary();
}

main();
