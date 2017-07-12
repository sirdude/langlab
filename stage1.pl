#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use LangLab::Parser;
use LangLab::Symbols;

use Getopt::Long;

my (%terminals, @tokens, %Options);

sub usage {
	print "\tUsage: $0 [--debug] filename(s)\n";
        print "Read in grammar files and convert to a list of characters.\n\n";

        return 1;
}

sub add_node {
}

sub process_line {
}

sub process_file {
	my ($infile) = @_;
	my ($fh, $error, $num);

	if (!open($fh, "<", $file) {
		print "Error opening $file\n";
		return 1;
	}

	$num = 0;
	while (<$fh>) {
		my $line = $_;
		$num = $num + 1;

		if (!process_line($line, $num, $file)) {
			$error = $error + 1;
		}
	}

	close($fh);

	add_node($Symbols::EOF, $file, $num, 0);

	return $error;
}

sub main {
	GetOptions(\%Options, "debug");

	if ($#ARGV < 0) {
		usage();
		return 1;
	}

	if (!load_terminals("terminals.txt")) {
		return 1;
	}

	foreach my $i (@ARGV) {
		process_file($i);
	}

	return 0;
}

main();
