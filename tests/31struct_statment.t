#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

use ast;
use tests;
use struct_statement;

my ($testast, $output);

sub test_assignment {
	$testast->add_base_node('ident', 'x', 0, 18);
	$testast->add_base_node('op', '=', 0, 19);
	$testast->add_base_node('int', '5', 0, 20);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_statement::start($testast), 1, 'Testing start of assignment.');
	is(struct_statement::get($testast, \$output), 1, 'Testing x=5;');

	$testast->clear();
	return 1;
}

sub test_label_goto {
	$testast->add_base_node('keyword', 'label', 0, 18);
	$testast->add_base_node('ident', 'HERE', 0, 20);
	$testast->add_base_node('op', ';', 0, 21);
	$testast->add_base_node('keyword', 'goto', 0, 18);
	$testast->add_base_node('ident', 'HERE', 0, 20);
	$testast->add_base_node('op', ';', 0, 21);
	is(struct_statement::get($testast, \$output), 1, 'Testing label;');
	is(struct_statement::get($testast, \$output), 1, 'Testing goto;');

	$testast->clear();
}

sub test_switch {
	$testast->add_base_node('keyword', 'switch', 0, 18);
	$testast->add_base_node('ident', 'values', 0, 20);
	$testast->add_base_node('op', '{', 0, 21);
	$testast->add_base_node('keyword', 'case', 0, 21);
	$testast->add_base_node('int', '5', 0, 21);
	$testast->add_base_node('op', '{', 0, 21);
	$testast->add_base_node('op', '}', 0, 21);
	$testast->add_base_node('keyword', 'default', 0, 21);
	$testast->add_base_node('op', '{', 0, 21);
	$testast->add_base_node('op', '}', 0, 21);
	$testast->add_base_node('op', '}', 0, 21);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_statement::get($testast, \$output), 1, 'Testing foreach');

	$testast->clear();
}

sub test_while {
	$testast->add_base_node('keyword', 'while', 0, 18);
	$testast->add_base_node('op', '(', 0, 21);
	$testast->add_base_node('ident', 'values', 0, 20);
	$testast->add_base_node('op', '<', 0, 21);
	$testast->add_base_node('int', '5', 0, 21);
	$testast->add_base_node('op', ')', 0, 21);
	$testast->add_base_node('op', '{', 0, 21);
	$testast->add_base_node('op', '}', 0, 21);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_statement::get($testast, \$output), 1, 'Testing foreach');

	$testast->clear();
}

sub test_dowhile {
	$testast->add_base_node('keyword', 'do', 0, 18);
	$testast->add_base_node('op', '{', 0, 21);
	$testast->add_base_node('op', '}', 0, 21);
	$testast->add_base_node('keyword', 'while', 0, 18);
	$testast->add_base_node('op', '(', 0, 21);
	$testast->add_base_node('ident', 'values', 0, 20);
	$testast->add_base_node('op', '<', 0, 21);
	$testast->add_base_node('int', '5', 0, 21);
	$testast->add_base_node('op', ')', 0, 21);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_statement::get($testast, \$output), 1, 'Testing foreach');

	$testast->clear();
}

sub test_if {
	$testast->add_base_node('keyword', 'if', 0, 18);
	$testast->add_base_node('op', '(', 0, 21);
	$testast->add_base_node('ident', 'values', 0, 20);
	$testast->add_base_node('op', '=', 0, 21);
	$testast->add_base_node('int', '5', 0, 21);
	$testast->add_base_node('op', ')', 0, 21);
	$testast->add_base_node('op', '{', 0, 21);
	$testast->add_base_node('op', '}', 0, 21);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_statement::get($testast, \$output), 1, 'Testing foreach');

	$testast->clear();
}

sub test_foreach {
	$testast->add_base_node('keyword', 'foreach', 0, 18);
	$testast->add_base_node('ident', 'x', 0, 18);
	$testast->add_base_node('op', '(', 0, 21);
	$testast->add_base_node('ident', 'values', 0, 20);
	$testast->add_base_node('op', ')', 0, 21);
	$testast->add_base_node('op', '{', 0, 21);
	$testast->add_base_node('op', '}', 0, 21);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_statement::get($testast, \$output), 1, 'Testing foreach');

	$testast->clear();
}

sub test_print {
	$testast->add_base_node('keyword', 'print', 0, 18);
	$testast->add_base_node('string', 'Hello Joe', 0, 20);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_statement::get($testast, \$output), 1, 'Testing print;');

	$testast->clear();
}

sub test_return {
	$testast->add_base_node('keyword', 'return', 0, 18);
	$testast->add_base_node('int', '1', 0, 20);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_statement::get($testast, \$output), 1, 'Testing return;');

	$testast->clear();
}

sub test_exit {
	$testast->add_base_node('keyword', 'exit', 0, 18);
	$testast->add_base_node('int', '1', 0, 20);
	$testast->add_base_node('op', ';', 0, 21);

	is(struct_statement::get($testast, \$output), 1, 'Testing exit;');

	$testast->clear();
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_assignment();
	test_label_goto();
	test_switch();
	test_while();
	test_dowhile();
	test_if();
	test_foreach();
	test_print();
	test_return();
	test_exit();
	return test_summary();
}

main();
