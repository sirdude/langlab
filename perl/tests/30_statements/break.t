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
use struct_break;

my ($testast, $output);

sub test_break {
	my %teststr = (
		'data' => 'void',
		'type' => 'break',
	);

	$testast->add_base_node('keyword', 'break', 0, 18);
	$testast->add_base_node('op', ';', 0, 19);

	is(struct_break::start($testast), 1, 'Testing start break');
	is(struct_break::get($testast, \%{$output}), 1, 'Testing get break');

	# print Dumper(\%{$output});
	is(compare_hash(\%{$output}, \%teststr), 1, 'Test output of get break');

	is(struct_break::start($testast), 0, 'Testing invalid start of break.');
	is(struct_break::get($testast, \%{$output}), 0, 'Testing get break invalid;');

	$testast->clear();
	return 1;
}

sub test_breaker {
	$testast->add_base_node('keyword', 'breaker', 0, 33);
	$testast->add_base_node('op', ';', 0, 34);

	is(struct_break::start($testast), 0, "Testing invalid start of break 'breaker'.");
	is(struct_break::get($testast, \%{$output}), 0, 'Testing get break invalid;');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_break();
	test_breaker();
	return test_summary();
}

main();
