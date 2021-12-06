#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 28;
use Test::Exception;

use lib "./lib";
use lib "../lib";

use ast;

my ($testdir, $testast);

sub test_file {
	my ($filename) = @_;

	unlink($filename . '.o');
	open_output($filename . '.o');

	is(read_compfile($filename), 1, "Testing file :$filename");

	close_compfile();
	close_output();
	return 1;
}

sub test_scope {

	is($testast->get_scope(), 0, 'Check inital scope.');
	$testast->push_scope();
	is($testast->get_scope(), 1, 'Check inital scope +1.');
	$testast->pop_scope();
	is($testast->get_scope(), 0, 'Check pop_scope.');

}

sub test_node_basics {
	$testast->add_node('char', 'a', 1, 0);
	is($testast->peek(), 'a', 'Testing peek with one insert.');
	$testast->add_node('char', 'b', 2, 0);
	is($testast->peek(), 'a', 'Testing peek with two inserts.');
	is($testast->peek(1), 'b', 'Testing peek(1) with two inserts.');
	$testast->add_node('char', 'c', 3, 0);
	$testast->add_node('char', 'd', 4, 0);
	is($testast->consume('a'), 'a', 'Testing consume(a).');
	is($testast->consume('bc'), 'a', 'Testing consume(b).');
	is($testast->peek(), 'd', 'Testing peek() after consume.');
}

sub main {
	$testast = ast->new();
	test_scope();
	test_node_basics();
}

main();
