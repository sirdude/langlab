#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_exp_list;

my ($testast, $output);

sub test_no_params {
	$testast->add_base_node('op', '(', 0, 18);
	$testast->add_base_node('op', ')', 0, 19);
	$testast->add_base_node('op', ';', 0, 20);

	is(struct_exp_list::start($testast), 1, 'Testing start exp_list');
	is(struct_exp_list::get($testast, \%{$output}), 1, 'Testing get no params');
	is(struct_exp_list::start($testast), 0, 'Testing invalid start of exp_list.');
	is(struct_exp_list::get($testast, \%{$output}), 0, 'Testing get exp_list invalid;');

	$testast->clear();
	return 1;
}

sub test_one_param {
	$testast->add_base_node('op', '(', 0, 32);
	$testast->add_base_node('ident', 'x', 0, 33);
	$testast->add_base_node('op', ')', 0, 34);
	$testast->add_base_node('op', ';', 0, 35);

	is(struct_exp_list::get($testast, \%{$output}), 1, 'Testing get one params');

	$testast->clear();
	return 1;
}

sub test_multi_params {
	$testast->add_base_node('op', '(', 0, 44);
	$testast->add_base_node('ident', 'x', 0, 45);
	$testast->add_base_node('op', ',', 0, 46);
	$testast->add_base_node('ident', 'y', 0, 47);
	$testast->add_base_node('op', ')', 0, 48);
	$testast->add_base_node('op', ';', 0, 49);

	is(struct_exp_list::get($testast, \%{$output}), 1, 'Testing get multi params.');

	$testast->clear();
	return 1;
}

sub test_invalid_multi_params {
	$testast->add_base_node('op', '(', 0, 58);
	$testast->add_base_node('ident', 'x', 0, 59);
	$testast->add_base_node('ident', 'y', 0, 60);
	$testast->add_base_node('op', ')', 0, 61);
	$testast->add_base_node('op', ';', 0, 62);

	is(struct_exp_list::get($testast, \%{$output}), 0, 'Testing invalid get multi params.');

	$testast->clear();
	return 1;
}


sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_no_params();
	test_one_param();
	test_multi_params();
	test_invalid_multi_params();
	return test_summary();
}

main();
