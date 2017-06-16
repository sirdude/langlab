#!/usr/bin/perl

use strict;
use warnings;

my (@tokens);

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
		} elsif ($line =~ /^$/) {
			# skip blank lines
		} elsif ($line =~ /^(\w+) (.*)$/) {
			$type = $1;
			$value = $2;

			if (!valid_type($type)) {
				print "Error line $c: invalid type $type\n";
			} else {
				my $node;
				$node->{"file"} = $infile;
				$node->{"line"} = $c;
				$node->{"column"} = 0; # XXX This should be figured out?
				$node->{"type"} = $type;
				$node->{"value"} = $value;

				push(@tokens, $node);
				
			}
		} else {
			print "Error line $c: $line\n";
		}
	}

	return 1;
}

sub write_file {
	my ($outfile) = @_;
	my ($fh);

	open($fh, ">", $outfile) or die "Unable to open $outfile for writing.\n";

	if (!$fh) {
		return 0;
	}
	foreach my $node (@tokens) {
		print $fh $node->{"type"} . " " . $node->{"value"} . "\n";
	}

	close($fh);

	return 1;
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
	write_file($filename . ".new");
}
