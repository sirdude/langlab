#!/usr/bin/perl

use strict;
use warnings;

use lib "../lib";
use options;

# XXX Instead of functioncalls and functioncallcount 
# we want to make a db of calls with values:
#	object is function call or variable reference
#	parent is function we are in
#	line# is line of source code this call is from.
my (@functionnames, @functioncalls, %functioncallcount);
my $debug = 0;

sub usage {
	print "Usage: $0 [OPTIONS] FILENAME\n\n";
	print "Check FILENAME function definitions and other things.\n";
	print "Perl is kind of lacking in this respect so lets write " .
		"our own.\n\n";

	print_options();

	return 1;
}

sub in_set {
	my ($val, @setlist) = @_;

	foreach my $i (@setlist) {
		if ($i eq $val) {
			return 1;
		}
	}
	return 0;
}

sub warning {
	my ($msg) = @_;

	print 'WARNING: ' . $msg . "\n";
	return 1;
}

# isNAME vs YY_GET_NAME
sub check_def_pairs {
	my $warnings = 0;
	foreach my $i (@functionnames) {
		if ($i =~ /^YY_is_(.*)$/) {
			my $fname = "YY_get_$1";
			if (!in_set($fname, @functionnames)) {
				warning("$fname undefined.");
				$warnings = $warnings + 1;
			}
		} elsif ($i =~ /^YY_get_(.*)$/) {
			my $fname = "YY_is_$1";
			if (!in_set($fname, @functionnames)) {
				warning("$fname undefined.");
				$warnings = $warnings + 1;
			}
		}
	}

	return $warnings;
}

sub check_funcalls {
	my $warnings = 0;

	foreach my $i (@functioncalls) {
		if ($i =~ /^(.*)\((.*)\)(.*)$/) {
			my $fname = $1;
			my $args = $2;

			if (!in_set($fname, @functionnames)) {
				warning("Function $fname undefined.");
				$warnings = $warnings + 1;
			}

			# XXX need to seperate out args and check them..

		}
	}

	foreach my $i (@functionnames) {
		if (!exists($functioncallcount{$i})) {
			warning("Function $i never called.");
			$warnings = $warnings + 1;
		}
	}

	return $warnings;
}

sub init_values {
	my ($infile) = @_;
	my ($fh, $line);
	my @builtin = ('debug', 'error', 'match', 'nextchar', 'get_char',
		'emit');

	open($fh,"<", $infile) or die "Unable to read $infile\n";

	while(<$fh>) {
		$line = $_;

		if ($line =~ /\s*sub\s*(\w*)\s*\{(.*)/) {
			push(@functionnames, $1);
		} elsif ($line =~ /(\w+)\((.*)\)(.*)$/) {
			my $name = $1;
			push(@functioncalls, $name);
			if (exists($functioncallcount{$name})) {
				$functioncallcount{$name} =
					$functioncallcount{$name} + 1;
			} else {
				$functioncallcount{$name} = 1;
			}
		}
	}
	close($fh);

	foreach my $i (@builtin) {
		push (@functionnames, $i);
	}

	if ($debug) {
		foreach my $i (@functionnames) {
			print "Adding function: $i\n";
		}

		foreach my $i (keys %functioncallcount) {
			print "Functioncall: $i $functioncallcount{$i}\n";
		}
	}

	return 1;
}

add_option("help", "Print this help message.");

my ($filename) = parse_options(@ARGV);

if (!$filename || query_option('help')) {
	usage();
} else {
	init_values($filename);
	check_def_pairs();
	check_funcalls();
}
