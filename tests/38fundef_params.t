#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_fundef_params;

my ($testast, $output);

sub test_no_params {
	$testast->add_base_node('op', '(', 0, 19);
	$testast->add_base_node('op', ')', 0, 19);
	$testast->add_base_node('op', ';', 0, 19);

	is(struct_fundef_params::start($testast), 1, 'Testing start params');
	is(struct_fundef_params::get($testast, $output), 1, 'Testing get no params');
	is(struct_fundef_params::start($testast), 0, 'Testing invalid start of params.');
	is(struct_fundef_params::get($testast, $output), 0, 'Testing get params invalid;');

	$testast->clear();
	return 1;
}

sub test_one_param {
	$testast->add_base_node('op', '(', 0, 19);
	$testast->add_base_node('type', 'int', 0, 19);
	$testast->add_base_node('ident', 'x', 0, 19);
	$testast->add_base_node('op', ')', 0, 19);
	$testast->add_base_node('op', ';', 0, 19);

	is(struct_fundef_params::get($testast, $output), 1, 'Testing get one params');

	$testast->clear();
	return 1;
}

sub test_multi_params {
	$testast->add_base_node('op', '(', 0, 19);
	$testast->add_base_node('type', 'int', 0, 19);
	$testast->add_base_node('ident', 'x', 0, 19);
	$testast->add_base_node('op', ',', 0, 19);
	$testast->add_base_node('type', 'int', 0, 19);
	$testast->add_base_node('ident', 'y', 0, 19);
	$testast->add_base_node('op', ')', 0, 19);
	$testast->add_base_node('op', ';', 0, 19);

	is(struct_fundef_params::get($testast, $output), 1, 'Testing get multi params.');

	$testast->clear();
	return 1;
}

sub test_invalid_multi_params {
	$testast->add_base_node('op', '(', 0, 19);
	$testast->add_base_node('type', 'int', 0, 19);
	$testast->add_base_node('ident', 'x', 0, 19);
	$testast->add_base_node('type', 'int', 0, 19);
	$testast->add_base_node('ident', 'y', 0, 19);
	$testast->add_base_node('op', ')', 0, 19);
	$testast->add_base_node('op', ';', 0, 19);

	is(struct_fundef_params::get($testast, $output), 0, 'Testing invalid get multi params.');

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
