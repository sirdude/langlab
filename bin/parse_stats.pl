#!/usr/bin/perl

use strict;
use warnings;
my %stats;

sub read_stats {
	my ($fname) = @_;
	my ($fh, $inc);

	$inc = 0;
	open($fh,"<", $fname) or die "Unable to open $fname\n";
	while(<$fh>) {
		my $line = $_;
		if ($line =~ /^(.*):(.*):(\d+)$/) {
			my ($type, $tok, $count) = ($1, $2, $3);
			if (exists($stats{"$type:$tok"})) {
				$stats{"$type:$tok"} = $stats{"$type:$tok"} +
					$count;
			} else {
				$stats{"$type:$tok"} = $count;
			}
			$inc = $inc + 1;
		} elsif ($line =~ /(.*):(.*)$/) {
			my ($val, $vcount) = ($1, $2);
			if (exists($stats{$val})) {
				$stats{$val} = $stats{$val} + $vcount;
			} else {
				$stats{$val} = $vcount;
			}
			$inc = $inc + 1;
		}
	}
	return $inc;
}

sub print_stats {
	my $pc = 0;
	my @specstats = ('linenum', 'columnnum', 'all_linenum',
		'totalchars', 'all_totalchars', 'tab','maxtab');

	foreach my $i (@specstats) {
		if (exists($stats{$i})) {
			print "\t$i: " . $stats{$i} . "\n";
			delete($stats{$i});
		}
	}

	print "Code frequency:\n";

	foreach my $key (sort {$stats{$b} <=> $stats{$a}} keys %stats) {
		my $found = 0;
		foreach my $tmp (@specstats) {
			if ($key eq $tmp) {
				$found = 1;
			}
		}
		if (!$found) {
			print sprintf("%20d :%s\n", $stats{$key}, $key);
		}
		$pc = $pc + 1;
	}
	return $pc;
}

print "Read in : " . read_stats("stats.txt") . " stats.";
print "\tTotal composite stats:\n";

print_stats();
