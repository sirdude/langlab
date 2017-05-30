#!/usr/bin/perl

use strict;
use warnings;

sub valid_type {
	my ($input) = @_;

	if ($input eq "delimiter") {
		return 1;
	} elsif ($input eq "string") {
		return 1;
	} elsif ($input eq "comment") {
		return 1;
	} elsif ($input eq "ident") {
		return 1;
	}
	return 0;
}

sub read_file {
	my ($infile) = @_;
	my ($fh, $type, $value, $c);

	open($fh, "<", $infile) or die "Unable to open $infile for reading.\n";
	$c = 0;
	while(<$fh>) {
		my $line = $_;

		$c = $c + 1;

		if ($line =~ /^#(.*)/) {
			# skip comments
		} elsif ($line =~ /^(\s)+ (.*)$/) {
			$type = $1;
			$value = $2;

			if (!valid_type($type)) {
				print "Error line $c: invalid type $type\n";
			} else {
				# XXX Need to set values here...
			}
		} else {
			print "Error line $c: $line\n";
		}
	}

	return 1;
}

sub write_file {
	my ($outfile) = @_;
}

sub usage {
	print "Usage: $0 (infile)\n";
	print "Read in a tokenize file\n";

	return 1;
}

my ($filename) = @ARGV;

if (!$filename || $filename eq "") {
	usage();
} else {
	read_file($filename);
	# write_file($filename . ".new");
}
