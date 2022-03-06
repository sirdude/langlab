#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";
use lib "../lib";

use ast;
use tests;

my ($testast);

sub test_scope {

	is($testast->get_scope(), 0, 'Check initial scope.');
	$testast->push_scope();
	is($testast->get_scope(), 1, 'Check initial scope +1.');
	$testast->push_scope();
	is($testast->get_scope(), 2, 'Check initial scope +2.');
	$testast->pop_scope();
	is($testast->get_scope(), 1, 'Check pop_scope.');
	$testast->pop_scope();
	$testast->pop_scope();
	is($testast->get_scope(), -1, 'Check pop_scope to -1');

	$testast->clear();
	return 1;
}

sub test_node_basics {
	$testast->add_base_node('char', 'a', 0, 32);
	$testast->add_base_node('char', 'b', 0, 33);
	$testast->add_base_node('char', 'c', 0, 34);
	$testast->add_base_node('char', 'd', 0, 35);
	is($testast->peek(), 'a', 'Testing peek with one insert.');
	is($testast->peek(), 'a', 'Testing peek with two inserts.');
	is($testast->peek(1), 'b', 'Testing peek(1) with two inserts.');
	is($testast->match('a'), 1, 'Testing match("a").');
	is($testast->match('ab'), 1, 'Testing match("ab").');
	is($testast->match('ad'), 0, 'Testing match("ad").');
	is($testast->match('d'), 0, 'Testing match("ad").');
	is($testast->match_type('char'), 1, 'Testing match_type("char").');
	is($testast->match_type('int'), 0, 'Testing match_type("char").');
	is($testast->consume('a'), 'a', 'Testing consume(a).');
	is($testast->consume('bc'), 'bc', 'Testing consume(b).');
	is($testast->peek(), 'd', 'Testing peek() after consume.');

	$testast->clear();
	is($testast->match_type('EOF'), 1, 'Testing match("EOF").');

	return 1;
}

sub test_stats {
	is($testast->query_stat('test', 'a'), 0, 'Testing empty stat');
	is($testast->add_stat('test', 'a' , 1), 1, 'Testing empty stat');
	is($testast->query_stat('test', 'a'), 1, 'Testing stat with 1');
	is($testast->set_stat('test', 'a', 5), 1, 'Testing set stat');
	is($testast->query_stat('test', 'a'), 5, 'Testing stat with 5');

	$testast->clear();
	return 1;
}

sub main {
	$testast = ast->new();
	init_tests();
	test_scope();
	test_node_basics();
	test_stats();
	return test_summary();
}

main();
