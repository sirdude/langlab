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
use struct_return;

my ($testast, $output);
my %teststr = { 'type'=> 'return', 'data'=> {}};

sub test_return {
	my %teststr = {
		'type' => 'return',
		'data' => {
			'type' => 'expression'
		}
	};

	$testast->add_base_node('keyword', 'return', 0, 20);
	$testast->add_base_node('int', '1', 0, 21);
	$testast->add_base_node('op', ';', 0, 22);

	is(struct_return::start($testast), 1, 'Testing start return');
	is(struct_return::get($testast, \%{$output}), 1, 'Testing get return');

	# print Dumper(\%{$output});
	is(%teststr, \%{$output}, 1, 'Testing output node of get return');

	is(struct_return::start($testast), 0, 'Testing invalid start of return.');
	is(struct_return::get($testast, \%{$output}), 0, 'Testing get return invalid;');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_return();
	return test_summary();
}

main();
