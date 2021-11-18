#!/usr/bin/perl
use strict;
use warnings;

use lib "../lib";
use options;
use ast;

# XXX This is defined in lib/ast.pm
our $EOF = '__YY_EOF___';

# Language specific modules...
use lib "../lib/sweet";
use comment;
use whitespace;
use ident;
use string;
use html;
use hex;
use num;
use op;

my ($charast, $tokast);

sub usage {
	print "$0: [OPTIONS] [FILENAMES | STR]\n";
	print "Parses the given list of files or considers input a string and parses that.\n";
	print "Converts input to a tree of nodes of tokens and computes stats for the inputs as well.\n";
	print "\n";

	print_options();

	return 1;
}

sub debug {
	my ($info) = @_;

	if (query_option('debug')) {
		print "$info\n";
		return 1;
	}

	return 0;
}

sub convert_to_tokens {
	my $done = 0;
	my $numerrors = 0;

	while (!$done) {
		if ($charast->match($EOF)) {
		$done = 1;
		} elsif (comment::start($charast)) {
			comment::get($charast, $tokast);
		} elsif (whitespace::start($charast)) {
			whitespace::get($charast, $tokast);
		} elsif (ident::start($charast)) {
			ident::get($charast, $tokast);
		} elsif (string::start($charast)) {
			string::get($charast, $tokast);
		} elsif (html::start($charast)) {
			html::get($charast, $tokast);
		} elsif (hex::start($charast)) {
			hex::get($charast, $tokast);
		} elsif (num::start($charast)) {
			num::get($charast, $tokast);
		} elsif (op::start($charast)) {
			op::get($charast, $tokast);
		} else {
			my $value = $charast->peek();
			my $ascii = ord($value);
			error("convert_to_tokens: invalid input: '" . $value .
				"' ascii: '" . $ascii . "'");
			$numerrors += 1;
		}
	}
	if ($numerrors > 0) {
		print "Number of errors in input: $numerrors\n";
		return 0;
	}
	return 1;
}

sub main {
	my @VALUES = @_;
	my $ret = 0;

	add_option("help", "Print usage statement.");
	add_option("debug", "Enable debugging mode.");
	add_option("xml", "Use xml format for output.");
	add_option("json", "Use json format for output.");

	if (!@VALUES) {
		return usage();
	}

	@VALUES = parse_options(@VALUES);
	if (query_option('help')) {
		return usage();
	}

	$charast = ast->new();
	$tokast = ast->new();

	if (query_option('debug')) {
		$charast->set_debug(1);
		$tokast->set_debug(1);
	}

	if ($charast->parse_file_or_string(@VALUES)) {
		$charast->add_stat('stats', 'linenum', 1);
                $charast->add_stat('stats', 'columnnum', 1);
		if (query_option('json')) {
			$ret = $charast->nodes_to_json();
		} elsif (query_option('xml')) {
			$ret = $charast->nodes_to_xml();
		} else {
			$ret = $charast->print_nodes();
		}
		$charast->write_stats("char_stats.txt");
		$charast->clear_stats();
	}

	convert_to_tokens($charast);
	$charast->write_stats("token_stats.txt");
	return $ret;
}

main(@ARGV);
