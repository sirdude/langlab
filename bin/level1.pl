#!/usr/bin/perl
use strict;
use warnings;

use lib "../lib";
use options;
use ast;

my ($charast);

sub usage {
	print "$0: [OPTIONS] [FILENAMES | STR]\n";
	print "Parses the given list of files or considers input a string and parses that.\n";
	print "Converts input to a tree of nodes of characters and computes stats for the inputs as well.\n";
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
	if (query_option('debug')) {
		$charast->set_debug(1);
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
	}
	return $ret;
}

main(@ARGV);
