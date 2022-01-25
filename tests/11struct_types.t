#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";
use lib "./lib/sweet";
use lib "../lib/sweet";

my @types = ('void', 'int', 'float', 'string', 'object', 'hash', 'mixed');
my @typemods = ('atomic', 'nomask', 'private', 'static');

use ast;
use tests;
use struct_types;

my ($testast, $output);

sub test_type {

	foreach my $i (@types) {
		$testast->add_base_node('type', $i, 0, 23);
		is(struct_types::is_type($testast), 1, "Testing is_type '$i'");
		$testast->clear();
	}
	$testast->add_base_node('ident', 'x', 0, 27);
	is(struct_types::is_type($testast), 0, "Testing is_type 'x'");
	$testast->clear();

	return 1;
}

sub test_typemod {
	foreach my $i (@typemods) {
		$testast->add_base_node('typemod', $i, 0, 36);
		is(struct_types::is_typemod($testast), 1, "Testing is_typemod '$i'");
		$testast->clear();
	}
	$testast->add_base_node('ident', 'x', 0, 40);
	is(struct_types::is_typemod($testast), 0, "Testing is_typemod 'x'");
	$testast->clear();

	return 1;
}

sub main {
	$testast = ast->new();
	$output = ast->new();
#	$testast->set_debug(1);
	init_tests();
	test_type();
	test_typemod();
	return test_summary();
}

main();
