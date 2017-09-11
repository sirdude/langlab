#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use LangLab::Parser;
use LangLab::Symbols;
use LangLab::Tokens;

use Getopt::Long;

my (@tokens, %Options);

sub usage {
	print "\tUsage: $0 [--debug] filename(s)\n";
        print "Read in grammar files and convert to a list of characters.\n\n";

        return 1;
}

sub process_line {
	my ($line, $c, $file) = @_;
	my $len = length($line) - 1;
	my $x = 0;

	while($x < $len) {
		my $char = substr($line,$x,1);
		my $f = Symbols::get_startchar($char);
		my $done = 0;
		my $sub;

		while (!$done && $f) {
			$sub = substr($line,$x,$f);

			if (Symbols::is_terminal($sub)) {
				$done = 1;
				Tokens::make_node($sub,"terminal", $file, $c, $x);
				$x = $x + $f;
			} else {
				$f = $f - 1;
			}
		}

		if (!$done) {
			print "Warning at line: $c unknown terminal at $x\n";
			print "$line\n";

			$sub = substr($line,$x,1);
			Tokens::make_node($sub, "unknown", $file, $c, $x);
			$x = $x + 1;
		}

	}
	Tokens::make_node($Symbols::EOL,"EOL", $file, $c, $x);

	return 1;
}

sub process_file {
	my ($file) = @_;
	my ($fh, $error, $num);

	if (!open($fh, "<", $file)) {
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

	my $node = Tokens::make_node($Symbols::EOF, "EOF", $file, $num, 0);
	push(@tokens, $node);

	return $error;
}

sub main {
	GetOptions(\%Options, "debug");

	if ($#ARGV < 0) {
		usage();
		return 1;
	}

	if (!Symbols::load_terminals("terminals.txt")) {
		return 1;
	}

	foreach my $i (@ARGV) {
		process_file($i);
	}

	# XXX do the work here...

	return 0;
}

main();
