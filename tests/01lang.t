#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 65;
use Test::Exception;

use lib "./lib";
use lib "../lib";
use backend;

my ($testdir);

sub test_file {
	my ($filename) = @_;

	unlink($filename . '.o');
	open_output($filename . '.o');

	is(read_compfile($filename), 1, "Testing file $filename");

	close_compfile();
	close_output();
	return 1;
}

load_backend('my_language.pl');
set_eof("^F");
init_backend(@keywords);

is(backend::YY_is_type("a"), 0, 'Check for invalid type');
is(backend::YY_is_type("int"), 1, 'Check for type int');
is(backend::YY_is_type("float"), 1, 'Check for type float');
is(backend::YY_is_type("string"), 1, 'Check for type string');
is(backend::YY_is_type("void"), 1, 'Check for type void');
is(backend::YY_is_type("mixed"), 1, 'Check for type mixed');
is(backend::YY_is_type("mapping"), 1, 'Check for type mapping');
is(backend::YY_is_type("object"), 1, 'Check for type object');

is(backend::YY_is_typemod("int"), 0, 'Check for invalid typemod');
is(backend::YY_is_typemod("static"), 1, 'Check for typemod static');
is(backend::YY_is_typemod("atomic"), 1, 'Check for typemod atomic');
is(backend::YY_is_typemod("private"), 1, 'Check for typemod private');
is(backend::YY_is_typemod("unsigned"), 1, 'Check for typemod unsigned');
is(backend::YY_is_typemod("nomask"), 1, 'Check for typemod nomask');

is(backend::YY_is_alpha("a"), 1, 'a is a valid letter');
is(backend::YY_is_alpha("p"), 1, 'p is a valid letter');
is(backend::YY_is_alpha("A"), 1, 'A is a valid letter');
is(backend::YY_is_alpha("z"), 1, 'z is a valid letter');
is(backend::YY_is_alpha("Z"), 1, 'Z is a valid letter');
is(backend::YY_is_alpha("3"), 0, '3 is not a valid letter');
is(backend::YY_is_alpha("%"), 0, '% is not a valid letter');
is(backend::YY_is_alpha("_"), 0, '_ is not a valid letter');

is(backend::YY_is_alphanum("Z"), 1, 'Z is an alphanumeral');
is(backend::YY_is_alphanum("0"), 1, '0 is an alphanumeral');
is(backend::YY_is_alphanum("_"), 1, '_ is an alphanumeral');
is(backend::YY_is_alphanum("-"), 1, '- is an alphanumeral');
is(backend::YY_is_alphanum("#"), 0, '# is not an alphanumeral');

is(backend::YY_is_addop("+"), 1, '+ is a addition operator');
is(backend::YY_is_addop("-"), 1, '- is a addition operator');
is(backend::YY_is_addop("#"), 0, '# is not a addition operator');

is(backend::YY_is_multop("*"), 1, '* is a multiplication operator');
is(backend::YY_is_multop("/"), 1, '/ is a multiplication operator');
is(backend::YY_is_multop("+"), 0, '+ is not a multiplication operator');

is(backend::YY_is_orop("|"), 1, '| is a or operator');
is(backend::YY_is_orop("&"), 1, '& is a or operator');
is(backend::YY_is_orop("+"), 0, '+ is not a or operator');

is(backend::YY_is_relop("="), 1, '= is a relational operator');
is(backend::YY_is_relop("!"), 1, '! is a relational operator');
is(backend::YY_is_relop("<"), 1, '< is a relational operator');
is(backend::YY_is_relop(">"), 1, '> is a relational operator');
is(backend::YY_is_relop("+"), 0, '+ is not a relational operator');

is(backend::YY_is_op("+"), 1, '+ is an operator');
is(backend::YY_is_op("-"), 1, '- is an operator');
is(backend::YY_is_op("*"), 1, '* is an operator');
is(backend::YY_is_op("/"), 1, '/ is an operator');
is(backend::YY_is_op("<"), 1, '< is an operator');
is(backend::YY_is_op(">"), 1, '> is an operator');
is(backend::YY_is_op("="), 1, '= is an operator');
is(backend::YY_is_op("!"), 1, '! is an operator');

is(backend::YY_is_whitespace(" "), 1, '(space) is whitespace');
is(backend::YY_is_whitespace("\t"), 1, '\\t is whitespace');
is(backend::YY_is_whitespace("\n"), 1, '\\n is whitespace');
is(backend::YY_is_whitespace("\r"), 1, '\\r is whitespace');
is(backend::YY_is_whitespace("a"), 0, 'a is not whitespace');

is(backend::YY_is_quotes("'"), 1, '\' starts a string');
is(backend::YY_is_quotes('"'), 1, '\" starts a string');
is(backend::YY_is_quotes('a'), 0, 'a does not start a string');

is(backend::YY_is_string("string"), 1, 'string type is string compatable');
is(backend::YY_is_string("int"), 1, 'int type is string compatable');
is(backend::YY_is_string("float"), 1, 'float type is string compatable');
is(backend::YY_is_string("object"), 0, 'object type is not string compatable');

if (-d "./tests") {
	$testdir = "./examples";
} else {
	$testdir = "../examples";
}

is(backend::intable("if"), 1, 'see if keyword if is in symbol table');
is(backend::intable("if"), 1, 'see if keyword if is in symbol table');
is(backend::intable("if"), 1, 'see if keyword if is in symbol table');

# This was working...
#test_file("$testdir/comment.sw");
test_file("$testdir/empty.sw");

# test_file("$testdir/exit.sw");
# test_file("$testdir/fun.sw");
# test_file("$testdir/if.sw");
# test_file("$testdir/include.sw");
# test_file("$testdir/return.sw");
# test_file("$testdir/var.sw");
# test_file("$testdir/while.sw");
# test_file("$testdir/write.sw");

#ok(backend::test_rule('tidy_getreturn','return 5;'),
#	'Test tidy_getreturn: return 5;');
