#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 190;
use Test::Exception;

use lib "./lib";
use lib "../lib";

use backend;
use options;

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

sub check_start_comments {
	backend::buf_clear();
	backend::buf_push("/*");
	is(backend::YY_start_comment(), 1, '/* starts a comment');
	backend::buf_push("/* test */");
	is(backend::YY_start_comment(), 1, '/* starts a comment2');

	backend::buf_clear();
	backend::buf_push("#");
	is(backend::YY_start_comment(), 1, '# starts a comment');
	backend::buf_push("# Test");
	is(backend::YY_start_comment(), 1, '# starts a comment2');

	backend::buf_clear();
	backend::buf_push("//");
	is(backend::YY_start_comment(), 1, '// starts a comment');
	backend::buf_push("// Test");
	is(backend::YY_start_comment(), 1, '// starts a comment');

	backend::buf_clear();
	backend::buf_push("f");
	is(backend::YY_start_comment(), 0, 'f does not start a comment');
	backend::buf_clear();
}

sub check_start_whitespace {
	backend::buf_clear();
	backend::buf_push("\n");
	is(backend::YY_start_whitespace(), 1, '\n starts whitespace');
	backend::buf_push("\ntest");
	is(backend::YY_start_whitespace(), 1, '\n starts whitespace2');

	backend::buf_clear();
	backend::buf_push("\t");
	is(backend::YY_start_whitespace(), 1, '\t starts whitespace');
	backend::buf_push("\ttest");
	is(backend::YY_start_whitespace(), 1, '\t starts whitespace2');

	backend::buf_clear();
	backend::buf_push(" ");
	is(backend::YY_start_whitespace(), 1, 'SPACE starts whitespace');
	backend::buf_push(" Test");
	is(backend::YY_start_whitespace(), 1, 'SPACE starts whitespace2');

	backend::buf_clear();
	backend::buf_push("\r");
	is(backend::YY_start_whitespace(), 1, '\r starts whitespace');
	backend::buf_push("\rtest");
	is(backend::YY_start_whitespace(), 1, '\r starts whitespace2');

	backend::buf_clear();
	backend::buf_push("f");
	is(backend::YY_start_whitespace(), 0, 'f does not start whitespace');
	backend::buf_clear();
}

sub test_start_string {
	backend::buf_clear();
	backend::buf_push("'");
	is(backend::YY_start_string(), 1, "' starts a string");
	backend::buf_push("'Test'");
	is(backend::YY_start_string(), 1, "' starts a string2");

	backend::buf_clear();
	backend::buf_push('"');
	is(backend::YY_start_string(), 1, '" starts a string');
	backend::buf_push('"Test"');
	is(backend::YY_start_string(), 1, '" starts a string2');

	backend::buf_clear();
	backend::buf_push("f");
	is(backend::YY_start_string(), 0, 'f does not start a string');
	backend::buf_clear();
}

sub test_start_html {
	backend::buf_clear();
	backend::buf_push("&#");
	is(backend::YY_start_html(""), 1, '&# starts a html');
	backend::buf_push("&#334;");
	is(backend::YY_start_html(""), 1, '&# starts a html2');

	backend::buf_clear();
	backend::buf_push("f");
	is(backend::YY_start_html(), 0, 'f does not start a html');
	backend::buf_clear();
}

sub test_start_number {
	backend::buf_clear();
	backend::buf_push("0");
	is(backend::YY_start_num(), 1, '0 starts a number');
	backend::buf_push("003.45");
	is(backend::YY_start_num(), 1, '0 starts a number2');

	backend::buf_clear();
	backend::buf_push("1");
	is(backend::YY_start_num(), 1, '1 starts a number');

	backend::buf_clear();
	backend::buf_push("2");
	is(backend::YY_start_num(), 1, '2 starts a number');

	backend::buf_clear();
	backend::buf_push("3");
	is(backend::YY_start_num(), 1, '3 starts a number');

	backend::buf_clear();
	backend::buf_push("4");
	is(backend::YY_start_num(), 1, '4 starts a number');

	backend::buf_clear();
	backend::buf_push("5");
	is(backend::YY_start_num(), 1, '5 starts a number');

	backend::buf_clear();
	backend::buf_push("6");
	is(backend::YY_start_num(), 1, '6 starts a number');

	backend::buf_clear();
	backend::buf_push("7");
	is(backend::YY_start_num(), 1, '7 starts a number');

	backend::buf_clear();
	backend::buf_push("8");
	is(backend::YY_start_num(), 1, '8 starts a number');

	backend::buf_clear();
	backend::buf_push("9");
	is(backend::YY_start_num(), 1, '9 starts a number');

	backend::buf_clear();
	backend::buf_push("f");
	is(backend::YY_start_num(), 0, 'f does not start a number');
	backend::buf_clear();
}

sub test_start_ident {
	foreach my $i ('A'..'Z') {
		backend::buf_clear();
		backend::buf_push($i);
		is(backend::YY_start_ident(), 1, "$i starts an ident");
	}
	foreach my $i ('a'..'z') {
		backend::buf_clear();
		backend::buf_push($i);
		is(backend::YY_start_ident(), 1, "$i starts an ident");
	}

	backend::buf_clear();
	backend::buf_push('cat');
	is(backend::YY_start_ident(), 1, "cat starts an ident");

	backend::buf_clear();
	backend::buf_push("0");
	is(backend::YY_start_ident(), 0, '0 does not start an ident');
	backend::buf_clear();
}

# Test start an operator
sub test_start_operator {
	foreach my $i ('|', '-', '!', '$', '%', '&', '(', ')', '*', '+', ',',
		'-', '.', '/', ':', ';', '<', '=', '>', '?', '@', '[', ']',
		'^', '`', '{', '}', '~', "\\") {
		backend::buf_clear();
		backend::buf_push($i);
		is(backend::YY_start_op(), 1, "$i starts an operator");
	}

	backend::buf_clear();
	backend::buf_push("+5345");
	is(backend::YY_start_op(), 1, "+5345 starts an operator");

	backend::buf_clear();
	backend::buf_push("f");
	is(backend::YY_start_op(), 0, 'f does not start an operator');
	backend::buf_clear();
}

sub test_YY_get_comment {
	backend::buf_clear();
	backend::buf_push('# Woo');
	is(backend::YY_get_comment(), 1,
		'A # comment returns 1 inside YY_get_comment');
	is(backend::last_token('value'), '# Woo',
		'A # comment has correct value');
	is(backend::last_token('type'), 'comment',
		'A # comment has correct type');

	backend::buf_clear();
	backend::buf_push('// Woo');
	is(backend::YY_get_comment(), 1,
		'A // comment returns 1 inside YY_get_comment');
	is(backend::last_token('value'), '// Woo',
		'A // comment has correct value');
	is(backend::last_token('type'), 'comment',
		'A // comment has correct type');

	backend::buf_clear();
	backend::buf_push("/* Woo\n  */");
	is(backend::YY_get_comment(), 1,
		'A multi line comment returns 1 inside YY_get_comment');
	is(backend::last_token('value'), "/* Woo\n  */",
		'A multi line comment has correct value');
	is(backend::last_token('type'), 'comment',
		'A multi line comment has correct type');

	backend::buf_clear();
	backend::buf_push("funtime");
	is(backend::YY_get_comment(), 0,
		'An ident returns 0 inside YY_get_comment');
	backend::buf_clear();
}

sub test_YY_get_whitespace {
	backend::buf_clear();
	backend::buf_push('    ');
	is(backend::YY_get_whitespace(), 1,
		'SPACES returns 1 inside YY_get_whitespace');
	is(backend::last_token('value'), '    ',
		'SPACES has correct value from YY_get_whitespace');
	is(backend::last_token('type'), 'whitespace',
		'SPACES has correct type from YY_get_whitespace');

	backend::buf_clear();
	backend::buf_push("\n");
	is(backend::YY_get_whitespace(), 1,
		'\n returns 1 inside YY_get_whitespace');
	is(backend::last_token('value'), "\n",
		'SPACES has correct value from YY_get_whitespace');
	is(backend::last_token('type'), 'whitespace',
		'\n has correct type from YY_get_whitespace');
	backend::buf_show();

	backend::buf_clear();
	backend::buf_push("\t");
	is(backend::YY_get_whitespace(), 1,
		'\t returns 1 inside YY_get_whitespace');
	is(backend::last_token('value'), "\t",
		'\t has correct value from YY_get_whitespace');
	is(backend::last_token('type'), 'whitespace',
		'\t has correct type from YY_get_whitespace');

	backend::buf_clear();
	backend::buf_push("\r");
	is(backend::YY_get_whitespace(), 1,
		'\r returns 1 inside YY_get_whitespace');
	is(backend::last_token('value'), "\r",
		'\r has correct value from YY_get_whitespace');
	is(backend::last_token('type'), 'whitespace',
		'\r has correct type from YY_get_whitespace');

	backend::buf_clear();
	backend::buf_push('w');
	is(backend::YY_get_whitespace(), 0,
		'YY_get_whitespace Fails with non whitespace char');
	backend::buf_clear();
}

sub test_YY_get_ident {
	backend::buf_clear();
	backend::buf_push('_woo');
	is(backend::YY_get_ident(), 1, '_woo returns 1 inside YY_get_ident');
	is(backend::last_token('value'), "_woo",
		'_woo has correct value from YY_get_ident');
	is(backend::last_token('type'), 'ident',
		'_woo has correct type from YY_get_ident');
	backend::buf_clear();

	backend::buf_clear();
	backend::buf_push('woo3');
	is(backend::YY_get_ident(), 1, 'woo3 return2 1 inside YY_get_ident');
	is(backend::last_token('value'), "woo3",
		'woo3 has correct value from YY_get_ident');
	is(backend::last_token('type'), 'ident',
		'woo3 has correct type from YY_get_ident');

	backend::buf_clear();
	backend::buf_push('Woo');
	is(backend::YY_get_ident(), 1, 'Woo returns 1 inside YY_get_ident');
	is(backend::last_token('value'), "Woo",
		'Woo has correct value from YY_get_ident');
	is(backend::last_token('type'), 'ident',
		'Woo has correct type from YY_get_ident');

	backend::buf_clear();
	backend::buf_push('3W');
	is(backend::YY_get_ident(), 0, '3W returns 0 inside YY_get_ident');
	backend::buf_clear();
}

sub test_YY_get_string {
	backend::buf_clear();
	backend::buf_push('"Test string"');
	is(backend::YY_get_string(), 1,
		'"Test string" returns 1 inside YY_get_string');
	is(backend::last_token('value'), "Test string",
		'"Test string" has correct value from YY_get_string');
	is(backend::last_token('type'), 'string',
		'"Test string" has correct type from YY_get_string');

	backend::buf_clear();
	backend::buf_push("'Test string'");
	is(backend::YY_get_string(), 1,
		"'Test string' returns 1 inside YY_get_string");
	is(backend::last_token('value'), 'Test string',
		"'Test string' has correct value from YY_get_string");
	is(backend::last_token('type'), 'string',
		"'Test string' has correct type from YY_get_string");

	backend::buf_clear();
	backend::buf_push("5");
	is(backend::YY_get_string(), 0, "5 returns 0 inside YY_get_string");
	backend::buf_clear();
}

sub test_YY_get_html {
	backend::buf_clear();
	backend::buf_push('&#003;');
	is(backend::YY_get_html(), 1, '&#003; returns 1 inside YY_get_html');
	is(backend::last_token('value'), '&#003;',
		'&#003; has correct value from YY_get_html');
	is(backend::last_token('type'), 'html',
		'&#003; has correct type from YY_get_html');

	backend::buf_clear();
	backend::buf_push('#00A;');
	is(backend::YY_get_html(), 0, '#00A; returns 0 inside YY_get_html');
	backend::buf_clear();

	is(backend::YY_get_html(), 0, '; returns 0 inside YY_get_html');
	backend::buf_clear();
}

sub test_YY_get_hex {
	backend::buf_clear();
	backend::buf_push('0x03');
	is(backend::YY_get_hex(), 1, '0x03 returns 1 inside YY_get_hex');
	is(backend::last_token('value'), '0x03',
		'0x03 has correct value from YY_get_hex');
	is(backend::last_token('type'), 'hex',
		'0x03 has correct type from YY_get_hex');

	backend::buf_clear();
	backend::buf_push('0xA3');
	is(backend::YY_get_hex(), 1, '0xA3 returns 1 inside YY_get_hex');
	is(backend::last_token('value'), '0xA3',
		'0xA3 has correct value from YY_get_hex');
	is(backend::last_token('type'), 'hex',
		'0xA3 has correct type from YY_get_hex');

	backend::buf_clear();
	backend::buf_push('0xZ3');
	is(backend::YY_get_hex(), 0, '0xZ3 returns 0 inside YY_get_hex');
	backend::buf_clear();
}

sub test_YY_get_num {
	backend::buf_clear();
	backend::buf_push('03');
	is(backend::YY_get_num(), 1, '03 returns 1 inside YY_get_num');
	is(backend::last_token('value'), '03',
		'03 has correct value from YY_get_num');
	is(backend::last_token('type'), 'int',
		'03 has correct type from YY_get_num');

	backend::buf_clear();
	backend::buf_push('03.03');
	is(backend::YY_get_num(), 1, '03.03 returns 1 inside YY_get_num');
	is(backend::last_token('value'), '03.03',
		'03.03 has correct value from YY_get_num');
	is(backend::last_token('type'), 'float',
		'03.03 has correct type from YY_get_num');

	backend::buf_clear();
	backend::buf_push('03.03.03');
	is(backend::YY_get_num(), 1, '03.03.03 returns 1 inside YY_get_num');
	is(backend::last_token('value'), '03.03',
		'03.03 has correct value from YY_get_num');
	is(backend::last_token('type'), 'float',
		'03.03 has correct type from YY_get_num');

	backend::buf_clear();
	backend::buf_push('A');
	is(backend::YY_get_num(), 0, 'A returns 0 inside YY_get_num');
	backend::buf_clear();
}

sub test_YY_get_op {
	backend::buf_clear();
	backend::buf_push('|');
	is(backend::YY_get_op(), 1, '| returns 1 inside YY_get_op');
	is(backend::last_token('value'), '|',
		'| has correct value from YY_get_op');
	is(backend::last_token('type'), 'op',
		'| has correct type from YY_get_op');

	backend::buf_clear();
	backend::buf_push('(');
	is(backend::YY_get_op(), 1, '( returns 1 inside YY_get_op');
	is(backend::last_token('value'), '(',
		'( has correct value from YY_get_op');
	is(backend::last_token('type'), 'op',
		'( has correct type from YY_get_op');

	backend::buf_clear();
	backend::buf_push('_');
	is(backend::YY_get_op(), 0, '_ returns 1 inside YY_get_op');
	backend::buf_clear();
}

sub main {
	add_option("debug", "Enable debugging mode.");
	add_option("help", "Print this usage message.");
	add_option("names", "Use ident names in stats not just the word ident.");
	add_option("output", "Set the output file.", "FILE");

	if (-d "./examples") {
		$testdir = "./examples";
		load_backend('./lib/my_bnf.pl');
	} else {
		$testdir = "../examples";
		load_backend('../lib/my_bnf.pl');
	}

	set_eof("^F");
	init_backend(@keywords);

	check_start_comments();
	check_start_whitespace();
	test_start_string();
	test_start_html();
	test_start_number();
	test_start_ident();
	test_start_operator();

	# This makes sure we are not in interactive mode...
	open_compfile("$testdir/getchar.txt");
	close_compfile("$testdir/getchar.txt");

	test_YY_get_comment();
	test_YY_get_whitespace();
	test_YY_get_ident();
	test_YY_get_string();
	test_YY_get_html();
	test_YY_get_hex();
	test_YY_get_num();
	test_YY_get_op();
}

main();
