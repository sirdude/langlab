#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use LangLab::Symbols;
use LangLab::Parser;

use Getopt::Long;

my (%Options);

sub usage {
	print "\tUsage: $0 [--debug] filenames(s)\n";
	print "Take a grammar and print out code to generate that language " .
		"from " a parse tree.\n";
	return 1;
}

sub generate_code {
	my (@tree) = @_;

	foreach my $i (@tree) {
	}
}

GetOptions(\%Options, "debug");


if ($#ARGV < 0) {
	usage();
	return 1;
}

#  XXX Need to load the parse tree here.

generate_code();
