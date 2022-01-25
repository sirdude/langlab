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
use struct_label;

my ($testast, $output);

sub test_label {
	$testast->add_base_node('keyword', 'label', 0, 18);
	$testast->add_base_node('ident', 'x', 0, 19);
	$testast->add_base_node('op', ';', 0, 22);

	is(struct_label::start($testast), 1, 'Testing start of label statement.');
	is(struct_label::get($testast, $output), 1, 'Testing label x;');
	is(struct_label::start($testast), 0, 'Testing start of label with ;.');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_label();
	return test_summary();
}

main();
