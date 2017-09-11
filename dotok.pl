#!/usr/bin/perl

use strict;
use warnings;
use IO::Prompter;

use lib ".";
use LangLab::Tokens;

sub valid_type {
	my ($input) = @_;

	if ($input eq "delimiter") {
		return 1;
	} elsif ($input eq "terminal") {
		return 1;
	} elsif ($input eq "string") {
		return 1;
	} elsif ($input eq "comment") {
		return 1;
	} elsif ($input eq "ident") {
		return 1;
	} elsif ($input eq "whitespace") {
		return 1;
	} elsif ($input eq "unknown") {
		return 1;
	}
	return 0;
}

sub usage {
	print "Usage: $0 (infile)\n";
	print "Read in a tokenize file\n";

	return 1;
}

sub check_file {
	my ($filename) = @_;

	if ($filename =~ /(.*).tok/) {
		return 1;
	} else {
		print "Warning $filename does not end in .tok do you want to " .
			"process it anyway?\n";
		my $answer = prompt "(y/n) ";
		if ($answer eq "y") {
			return 1;
		}
	}

	return 0;	
}

my ($filename) = @ARGV;

if (!$filename || $filename eq "") {
	usage();
} else {
	if (!check_file($filename)) {
		exit(1);
	}
	Tokens::read_tok_file($filename);
	Tokens::write_tok_file($filename . ".new");
}
