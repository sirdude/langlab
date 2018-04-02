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

sub process_line_chr {
	my ($line, $c, $file) = @_;
	my ($tok, $f, $l, $p, $type);

	if ($line =~ /^make_node\((.*), (.*), (\d+), (\d+)/) {
		$tok = $1;
		$f = $2;
		$l = $3;
		$p = $4;

		if (Symbols::is_terminal($tok)) {
			$type = "terminal";
		} else {
			$type = "unknown";
		}

		Tokens::make_node($tok, $type, $f, $l, $p);
		return 1;
	}

	return 0;
}

sub process_line_bnf {
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
				Tokens::make_node($sub,"terminal", $file, $c,
					$x);
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
	my ($fh, $error, $num, $infiletype);

	if (!open($fh, "<", $file)) {
		print "Error opening $file\n";
		return 1;
	}

	if ($file =~ /(.*)\.bnf/) {
		$num = 0;
		while (<$fh>) {
			my $line = $_;
			$num = $num + 1;

			if (!process_line_bnf($line, $num, $file)) {
				$error = $error + 1;
			}
		}
	} elsif ($file =~ /(.*)\.chr/) {
		$num = 0;
		while (<$fh>) {
			my $line = $_;
			$num = $num + 1;

			if (!process_line_chr($line, $num, $file)) {
				$error = $error + 1;
			}
		}
	} else {
		print "You should run this on a .bnf or a .chr\n";
		exit 1;
	}

       
	$num = 0;
	while (<$fh>) {
		my $line = $_;
		$num = $num + 1;

		if (!process_line($infiletype, $line, $num, $file)) {
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
	my ($outfile1, $outfile2);

	if ($#ARGV < 0) {
		usage();
		return 1;
	}

	if (!Symbols::load_terminals("terminals.txt")) {
		return 1;
	}

	foreach my $i (@ARGV) {
		process_file($i);

		if ($i =~ /(.*)\.bnf/) {
			$outfile1 = "$1.bnf.new";
			$outfile2 = "$1.chr.new";
		} elsif ($i =~ /(.*)\.chr/) {
			$outfile1 = "$1.bnf.new";
			$outfile2 = "$1.chr.new";
		}
		Tokens::write_tok_file($outfile2);
		Tokens::write_file($outfile1);
	}

	return 0;
}

main();
