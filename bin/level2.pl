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
			tok_ident::get($inast, $outast, query_option('expand-stats'));
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
			print("convert_to_tokens: invalid input: '" . $value .
				"' ascii: '" . $ascii . "'\n");
			$numerrors += 1;
		}
	}
	if ($numerrors > 0) {
		print "Number of errors in input: $numerrors\n";
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

sub main {
	my @VALUES = @_;
	my $ret = 0;

	add_option('help', 'Print usage statement.');
	add_option('debug', 'Enable debugging mode.');
	add_option('expand-stats', 'Dig a little deeper not just reporting types for comments, strings, idents.');
	add_option('output-char-file', 'Filename for output charaters.');
	add_option('output-tok-file', 'Filename for output tokens.');

	if (!@VALUES) {
		return usage();
	}

	@VALUES = parse_options(@VALUES);
	if (query_option('help') || !@VALUES) {
		return usage();
	}

	$charast = ast->new();
	$tokast = ast->new();
	if (query_option('expand-stats')) {
		$charast->{'expand-stats'} = 1;
		$tokast->{'expand-stats'} = 1;
	}

	if (query_option('debug')) {
		$charast->set_debug(1);
		$tokast->set_debug(1);
	}

	if ($charast->parse_file_or_string(@VALUES)) {
		my $filename = query_option('output-char-file');
		if ($filename) {
			if (has_extension($filename, 'json')) {
				$ret = $charast->nodes_to_json($filename);
			} elsif (has_extension($filename, 'xml')) {
				$ret = $charast->nodes_to_xml($filename);
			} else {
				$ret = $charast->print_nodes($filename);
			}
		}
		$charast->write_stats('char_stats.txt');
	}

	convert_to_tokens($charast, $tokast);
	my $filename = query_option('output-tok-file');
	if ($filename) {
		if (has_extension($filename, 'json')) {
			$ret = $tokast->nodes_to_json($filename);
		} elsif (has_extension($filename, 'xml')) {
			$ret = $tokast->nodes_to_xml($filename);
		} else {
			$ret = $tokast->print_nodes($filename);
		}
	}
	$tokast->write_stats('token_stats.txt');
	return $ret;
}

main(@ARGV);
