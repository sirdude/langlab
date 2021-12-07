#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 28;
use Test::Exception;

use lib "./lib";
use lib "../lib";

use backend;
use options;

my $testdir;

sub test_file {
	my ($filename) = @_;

	unlink($filename . '.o');
	open_output($filename . '.o');

	is(read_compfile($filename), 1, "Testing file :$filename");

	close_compfile();
	close_output();
	return 1;
}

sub test_get_char {
	ok(open_compfile("$testdir/getchar.txt"), "Open $testdir/getchar.txt.");
	is(backend::get_char(), "#", 'Read values with getchar.');
	is(backend::get_char(), "\n", 'Read values with getchar.');
	is(backend::get_char(), "\\", 'Read values with getchar.');
	is(backend::get_char(), "n", 'Read values with getchar.');
	is(backend::get_char(), "\n", 'Read values with getchar.');
	is(backend::get_char(), "\\", 'Read values with getchar.');
	is(backend::get_char(), "r", 'Read values with getchar.');
	is(backend::get_char(), "\n", 'Read values with getchar.');
	is(backend::get_char(), " ", 'Read values with getchar.');
	is(backend::get_char(), "\n", 'Read values with getchar.');
	is(backend::get_char(), "\\", 'Read values with getchar.');
	is(backend::get_char(), "\\", 'Read values with getchar.');
	is(backend::get_char(), "\n", 'Read values with getchar.');
	is(backend::get_char(), '^F', 'Read values with getchar.');
	ok(close_compfile(), 'Close getchar.txt.');
}

sub test_symbol_table {
	is(backend::insert_symbol("x","int",10), 1,
		'Insert variable x=10(int) into symbol table.');
	is(backend::insert_symbol("x","int",10), 0, 'Insert same symbol twice.');

	is(backend::intable("0"), 0, 'See if invalid entry is in symbol table.');
	is(backend::intable("x"), 1, 'See if variable x is in symbol table.');

	is(backend::lookup_value("0"), "", 'Lookup value of invalid entry.');
	is(backend::lookup_value("x"), 10, 'Lookup value of variable x.');

	is(backend::lookup_type("0"), "", 'Lookup type of invalid entry.');
	is(backend::lookup_type("x"),"int", 'Lookup type of variable x.');

	# Make sure still not in the table after the other checks.
	is(backend::intable("0"), 0,
		'Intable correctly identifies 0 not in symbol table.');

	test_file("$testdir/empty.sw");
}

sub main {
	add_option("debug", "Enable debugging mode.");
	add_option("help", "Print this usage message.");
	add_option("names", "Use ident names in stats not just the word ident.");
	add_option("output", "Set the output file.", "FILE");

	if (-d "./examples") {
       	 $testdir = "./examples";
		is (::backend::load_backend('./lib/my_bnf.pl'), 1,
			'Test loading a backend file.');
	} else {
       	 $testdir = "../examples";
		is (::backend::load_backend('../lib/my_bnf.pl'), 1,
			'Test loading a backend file.');
	}

	is (::backend::set_eof("^F"), "^F", 'Test setting EOF.');
	init_backend(@keywords);

# don't need this function on perl... init_tests();

	test_get_char();
	test_symbol_table();
}

main();
