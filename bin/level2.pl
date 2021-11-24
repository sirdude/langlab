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

my ($charast, $tokast);

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
		if ($charast->at_eof()) {
		$done = 1;
		} elsif (tok_comment::start($charast)) {
			tok_comment::get($charast, $tokast);
		} elsif (tok_whitespace::start($charast)) {
			tok_whitespace::get($charast, $tokast);
		} elsif (tok_ident::start($charast)) {
			tok_ident::get($charast, $tokast);
		} elsif (tok_string::start($charast)) {
			tok_string::get($charast, $tokast);
		} elsif (tok_html::start($charast)) {
			tok_html::get($charast, $tokast);
		} elsif (tok_hex::start($charast)) {
			tok_hex::get($charast, $tokast);
		} elsif (tok_num::start($charast)) {
			tok_num::get($charast, $tokast);
		} elsif (tok_op::start($charast)) {
			tok_op::get($charast, $tokast);
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
	if (query_option('help') || !@VALUES) {
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
