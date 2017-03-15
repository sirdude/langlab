#!/usr/bin/perl

use strict;
use warnings;

sub usage {
	print "Usage: $0 filename\n";

	return 1;
}

sub process_file {
	my ($file) = @_;

	return 1;
}

if ($#ARGV < 1) {
	usage();
	exit 1;
}

foreach my $i (@ARGV) {
	process_file($i);
}
