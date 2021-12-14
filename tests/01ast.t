#!/usr/bin/perl

use strict;
use warnings;
# use Test::More tests => 9;
# use Test::Exception;

use lib "./lib";
use lib "../lib";

use ast;
use tests;

my ($testast);

sub test_scope {

	is($testast->get_scope(), 0, 'Check inital scope.');
	$testast->push_scope();
	is($testast->get_scope(), 1, 'Check inital scope +1.');
	$testast->push_scope();
	is($testast->get_scope(), 2, 'Check inital scope +2.');
	$testast->pop_scope();
	is($testast->get_scope(), 1, 'Check pop_scope.');
	$testast->pop_scope();
	$testast->pop_scope();
	is($testast->get_scope(), -1, 'Check pop_scope to -1');

	return 1;
}

sub test_node_basics {
	$testast->add_node('char', 'a', 1, 0);
	is($testast->peek(), 'a', 'Testing peek with one insert.');
	$testast->add_node('char', 'b', 2, 0);
	is($testast->peek(), 'a', 'Testing peek with two inserts.');
	is($testast->peek(1), 'b', 'Testing peek(1) with two inserts.');
	is($testast->match('a'), 1, 'Testing match("a").');
	is($testast->match('ab'), 1, 'Testing match("ab").');
	is($testast->match('ad'), 0, 'Testing match("ad").');
	is($testast->match('d'), 0, 'Testing match("ad").');
	$testast->add_node('char', 'c', 3, 0);
	$testast->add_node('char', 'd', 4, 0);
	is($testast->consume('a'), 'a', 'Testing consume(a).');
	is($testast->consume('bc'), 'bc', 'Testing consume(b).');
	is($testast->peek(), 'd', 'Testing peek() after consume.');

	return 1;
}

sub test_stats {
	is($testast->query_stat('test', 'a'), 0, 'Testing empty stat');
	is($testast->add_stat('test', 'a' , 1), 1, 'Testing empty stat');
	is($testast->query_stat('test', 'a'), 1, 'Testing stat with 1');
	is($testast->set_stat('test', 'a', 5), 1, 'Testing set stat');
	is($testast->query_stat('test', 'a'), 5, 'Testing stat with 5');

	return 1;
}

sub main {
	$testast = ast->new();
	init_tests();
	test_scope();
	test_node_basics();
	test_stats();
	test_summary();

	return 1;
}

main();
