#!/usr/bin/perl

use strict;
use warnings;

my $increment; # size to grow our hash table by when needed 
my $buckets;   # current number of buckets in our hash
my $maxdepth;  # depth that triggers a growth in our hash table
my $type;      # type of hash
my @items;

sub print_items {
	my ($x) = @_;
        my $c = 0;

        my $tmp = $items[$x];
        while ($tmp) {
		print "bucket[$x] item[$c]: key " . $tmp->{'key'} .
			" value: " . $tmp->{'value'} . "\n";
		$c = $c + 1;
		$tmp = $tmp->{'next'};
        }
}

sub dump_hash {
	my $x;
	print "buckets: $buckets\n";
	print "growth size: $increment\n";
	print "max depth: $maxdepth\n";
	print "type: %type\n\n";

	$x = 0;
	while ($x < $buckets) {
		print_items($x);
		$x = $x + 1;
	}
}

sub valid_type {
	my ($type) = @_;

	if ($type eq "string") {
		return 1;
	} elsif ($type eq "int") {
		return 1;
	} elsif ($type eq "float") {
		return 1;
	} elsif ($type eq "object") {
		return 1;
	} elsif ($type eq "hash") {
		return 1;
	} elsif ($type eq "mixed") {
		return 1;
	}
	return 0;
}

sub get_bucket {
	my ($input) = @_;
	my ($bucket, $tmp);

	$tmp = atoi($input);
	$bucket = $tmp % $buckets;
	return $bucket;
}

sub grow_hash {
# XXX
}

sub insert_item {
	my ($key, $value) = @_;
}

sub remove_item {
	my ($key, $value) = @_;
}

sub lookup_item {
	my ($key) = @_;
}

sub main {
	$increment = 100;
	$maxdepth = 10;
	$buckets = $increment;
}

main();
