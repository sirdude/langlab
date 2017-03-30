#!/usr/bin/perl

use strict;
use warnings;

my (%terminals, %startchars, $debug);

sub usage {
	print "\tUsage: $0 filename(s)\n";
	print "Examine grammar files and print stats about it.\n\n";

	return 1;
}

sub add_terminal {
	my ($tmp) = $_;

	if ($debug) {
		print "DEBUG: add_terminal($tmp)\n";
	}

	my $l = length($tmp);
	my $first = substr($tmp,0,1);

	if (exists($terminals{$tmp})) {
		$terminals{$tmp} = $terminals{$tmp} + 1;
	} else {
		$terminals{$tmp} = 1;
	}

	if (exists($startchars{$first})) {
		my $r = $startchars{$first};
		if ($r < $l) {
			$startchars{$first} = $l;
		}
	} else {
		$startchars{$first} = $l;
	}

	return 1;
}

sub load_terminals {
	my ($infile) = @_;
	my ($fh, $c);

	if (!open($fh, "<", $infile)) {
		print "Error could not read terminals from file: $infile\n";
		return 0;
	}

	$c = 0;
	while(<$fh>) {
		my $tline = chomp $_;

		add_terminal($tline);
	}

	return 1;
}

sub process_line {
	my ($line) = @_;

	return 1;
}

sub process_file {
	my ($file) = @_;
	my ($fh, $error);

	if (!open($fh, "<", $file)) {
		print "Error opening $file\n";
		return 1;
	}

	while(<$fh>) {
		my $line = $_;
		if (!process_line($line)) {
			$error = $error + 1;
		}
	}

	return $error;
}

sub print_terminal_info {
	my $t=0;
	my $c=0;

	foreach my $i (keys %terminals) {
		$t = $t + 1;
		print "Terminal \"$i\" : $terminals{$i}\n";
		if ($terminals{$i} > 1) {
			print "Error Duplicate terminal $i\n";
		}
	}

	print "\n";

	foreach my $i (keys %startchars) {
		$c = $c + 1;
		print "Startchars \"$i\" : $startchars{$i}\n";
	}

	print "\nTerminals: $t startchars = $c\n";
}

if ($#ARGV < 0) {
	usage();
	exit 1;
}

if (!load_terminals("terminals.txt")) {
	exit(1);
}

print_terminal_info();

foreach my $i (@ARGV) {
	process_file($i);
}
