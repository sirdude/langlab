#!/usr/bin/perl
use strict;
use warnings;

use lib "../lib";
use options;
use ast;

# Language specific modules...
use lib "../lib/sweet";
use tok_comment;
use tok_whitespace;
use tok_ident;
use tok_string;
use tok_html;
use tok_hex;
use tok_num;
use tok_op;

use struct_program;

my ($charast, $tokast, $progast);

sub usage {
	print "$0: [OPTIONS] [FILENAMES | STR]\n";
	print "Parses the given list of files or considers input a string and " .
		"parses that.\n";
	print "Converts input to a tree of nodes of tokens and computes stats " .
		"for the inputs as well.\n";
	print "\n";

	print_options();

	return 1;
}

sub convert_to_tokens {
	my ($inast, $outast) = @_;
	my $done = 0;
	my $numerrors = 0;

	while (!$done) {
		if ($inast->at_eof()) {
		$done = 1;
		} elsif (tok_comment::start($inast)) {
			tok_comment::get($inast, $outast);
		} elsif (tok_whitespace::start($inast)) {
			tok_whitespace::get($inast, $outast);
		} elsif (tok_ident::start($inast)) {
			tok_ident::get($inast, $outast);
		} elsif (tok_string::start($inast)) {
			tok_string::get($inast, $outast);
		} elsif (tok_html::start($inast)) {
			tok_html::get($inast, $outast);
		} elsif (tok_hex::start($inast)) {
			tok_hex::get($inast, $outast);
		} elsif (tok_num::start($inast)) {
			tok_num::get($inast, $outast);
		} elsif (tok_op::start($inast)) {
			tok_op::get($inast, $outast);
		} else {
			my $value = $inast->peek();
			my $ascii = ord($value);
			$inast->error("convert_to_tokens: invalid input: '" . $value .
				"' ascii: '" . $ascii . "'");
			$numerrors += 1;
		}
	}
	if ($numerrors > 0) {
		$inast->error("Number of errors in input: $numerrors");
		return 0;
	}
	return 1;
}

sub has_extension {
	my ($fname, $ext) = @_;

	$fname = lc($fname);
	if ($fname =~ /.*\.$ext/) {
		return 1;
	}
	return 0;
}

sub outputfile {
	my ($filename, $printast, $statsfile) = @_;
	my $ret  = 1;

	$printast->write_stats($statsfile);

	if ($filename) {
		if (has_extension($filename, 'json')) {
			$ret = $printast->nodes_to_json($filename);
		} elsif (has_extension($filename, 'xml')) {
			$ret = $printast->nodes_to_xml($filename);
		} else {
			$ret = $printast->print_nodes($filename);
		}
	}

	return $ret;
}

sub main {
	my @VALUES = @_;
	my @flags = ('expand-stats', 'debug', 'keep-ws');

	if (!@VALUES) {
		return usage();
	}

	add_option('help', 'Print usage statement.');
	add_option('debug', 'Enable debugging mode.');
	add_option('expand-stats',
		'Dig a little deeper not just reporting types for comments, strings, idents.');
	add_option('keep-ws', 'Keep whitespace and Comment Tokens.');
	add_option('output-char-file', 'Filename for output characters.');
	add_option('output-tok-file', 'Filename for output tokens.');
	add_option('output-ast-file', 'Filename for output AST.');

	@VALUES = parse_options(@VALUES);

	if (query_option('help') || !@VALUES) {
		return usage();
	}

	$charast = ast->new();
	$tokast = ast->new();
	$progast = ast->new();

	foreach my $i (@flags) {
		$charast->{$i} = query_option($i);
		$tokast->{$i} = query_option($i);
		$progast->{$i} = query_option($i);
	}

	if (!$charast->parse_file_or_string(@VALUES)) {
		return 0;
	}

	if (!outputfile(query_option('output-char-file'), $charast, 'char_stats.txt')) {
		return 0;
	}

	if (!convert_to_tokens($charast, $tokast)) {
		return 0;
	}

	if (!outputfile(query_option('output-tok-file'), $tokast, 'token_stats.txt')) {
		return 0;
	}

	$charast = ();

	if (!struct_program::get($tokast, $progast)) {
		return 0;
	}

	if (!outputfile(query_option('output-ast-file'), $progast, 'ast_stats.txt')) {
		return 0;
	}

	$tokast = ();
	return 1;
}

main(@ARGV);
