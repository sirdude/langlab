#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";

use tests;

my ($testast);

sub test_add_test {
	my ($x, $y);

	$y = total_tests() + 2;
	add_test();
	add_test();
	$x = total_tests();
	if ($x eq $y) {
		print "Tesing add_test and total_tests is a sucesses.\n";
	} else {
		print "Testing add_test and total_tests failed.\n";
	}
	$y = total_success() + 2;
	add_success();
	add_success();
	$x = total_success();
	if ($x eq $y) {
		print "Tesing add_success and total_success is a sucesses.\n";
	} else {
		print "Testing add_success and total_success failed.\n";
	}
	return 1;
}

sub test_init_tests {
	add_test();
	add_success();
	init_tests();
	if (total_tests() == 0) {
		if (total_success() == 0) {
			add_success();
			print "init_tests test successful.\n";
		} else {
			print "Error in init_tests, total_success != 0\n";
		}
	} else {
		print "Error in init_tests, total_tests != 0\n";
	}
	add_test();

	return 1;
}

sub test_basic_is {
	my ($x, $y, $z, $w);

	$y = total_success() + 1;
	is($x, $x, 'Testing test_basic_is true');
	$x = total_success();
	if ($y == $x) { 
		print "Success testing basic_is true\n";
	} else {
		print "Failure testing basic_is true x= $x y = $y\n";
	}
	$x = total_success() + 1;
	$w = total_tests() + 2;
	is(is_quiet($x, 1, ''), 0, 'Testing test_basic_is False');
	$y = total_success();
	$z = total_tests();

	if ($x == $y) {
		print "total success correct for false test.\n";
	} else {
		print "ERROR: total success not correct for false test.\n";
	}

	if ($w == $z) {
		print "total tests correct for false test.\n";
	} else {
		print "ERROR: total tests not correct for false test.\n";
	}

	return 1;
}

sub test_array_compare {
	my @values = ('1', '2', '3');
	my @values2 = ('1', '2', '3', '4');

	is(compare_array(\@values, \@values), 1, 'Testing compare_array with equal arrays');
	is(compare_array(\@values, \@values2), 0, 'Testing compare_array with unequal arrays');
}

sub test_hash_compare {
	my (%h1, %h2);
	$h1{'test'} = 'wah';
	$h2{'test'} = 'wah';
	$h1{'test2'} = 'wah';

	is(compare_hash(\%h1, \%h1), 1, 'Testing compare_hash with equal hashes');
	is(compare_hash(\%h1, \%h2), 0, 'Testing compare_hash with unequal hashes');
}

sub test_hash_of_hash_compare {
	my (%h1, %h2, %h3);

	$h1{'type'} = 'hash_test';
	$h3{'type'} = 'hash_test';
	$h2{'test'} = 'test';
	$h1{'value'} = %h2;
	$h3{'value'} = %h2;

	is(compare_hash(\%h1, \%h3), 1, 'Testing comare_hash with equal hashes and nested hash');
	$h3{'value'} = %h1;
	is(compare_hash(\%h1, \%h3), 0, 'Testing comare_hash with unequal hashes and nested hash');
}

sub main {
	print "\n\nWARINGING you may see failures in this test that are not falures read carefully.\n";
	print "The total number of tests and falures may also " .
		"not be accurate since we are testing the testing module.\n\n";
	init_tests();
	test_init_tests();
	test_add_test();
	test_basic_is();
	test_array_compare();
	test_hash_compare();
	test_hash_of_hash_compare();
	return test_summary();
}

main();
