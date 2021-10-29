#!/usr/bin/perl
use strict;
use warnings;

my @NODES;
my $EOL = 111111111111111;
my $EOF = 222222222222222;

sub usage {
	print "$0: [FILENAMES | STR]\n";
	print "Parses the given list of files or considers input a string and parses that.\n";
	print "\n";

	return 1;
}

sub add_node {
	my ($data) = @_;
	my %node;

	if ($data eq $EOF) {
		$node{'type'} = 'EOF';
	} elsif ($data eq $EOL) {
		$node{'type'} = 'EOL';
	} else {
		$node{'type'} = 'char';
		$node{'data'} = $data;
	}
	push(@NODES, %node);

	return 1;
}

sub parse_string {
	my ($string) = @_;

	foreach my $i (split //, $string) {
		if ($i eq "\n") {
			add_node($EOL);
		} else {
			add_node($i);
		}
	}
	add_node($EOF);
	return 1;
}

sub parse_file {
	my ($fname) = @_;
	my $fh;

	if (open($fh, "<", $fname)) {
		while (<$fh>) {
			my $c = $_;
			if ($c eq "\n") {
				add_node($EOL);
			} else {
				add_node($c);
			}
		}
		close($fh);
		add_node($EOF);
		return 1;
	} else {
		return 0;
	}
}

sub get_usage_type {
	my @values = @_;
	my $tmp = 1;

	if (-f $values[0]) {
		foreach my $i (@values) {
			if (!parse_file($i)) {
				print "Error parsing file $i\n";
				$tmp = 0;
			}
		}
		return $tmp;
	} else {
		my $str = join(' ', @values);
		return parse_string($str);
	}
}

if (!@ARGV) {
	usage();
} else {
	get_usage_type(@ARGV);
}