#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my (%terminals, %startchars, @tokens, @parse_tokens, %Options);

my $EOF = "EOF__XXX";
my $EOL = "EOL__XXX";

sub usage {
	print "\tUsage: $0 [--debug] filename(s)\n";
	print "Examine grammar files and print stats about it.\n\n";

	return 1;
}

sub add_terminal {
	my ($tmp) = $_;

	if ($Options{"debug"}) {
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

	if ($Options{"debug"}) {
		print "\ncalling: load_terminals($infile)\n";
	}

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

sub add_node {
	my ($tok, $file, $line, $pos) = @_;

	if ($Options{"debug"}) {
		print "add_node($tok, $file, $line, $pos)\n";
	}

	my $node;

	$node->{"file"} = $file;
	$node->{"line"} = $line;
	$node->{"pos"} = $pos;
	$node->{"value"} = $tok;

	if ($tok eq $EOF) {
		$node->{"type"} = $EOF;
	} elsif ($tok eq $EOL) {
		$node->{"type"} = $EOL;
	} else {
		$node->{"type"} = "token";
	}

	push(@tokens, $node);

	return 1;
}

sub print_nodes {
	my $c = 0;

	foreach my $i (@tokens) {
		$c = $c + 1;
		print "Token: $c Value: " . $i->{'value'} . " Type: " .
			$i->{'type'};

		if ($Options{"debug"}) {
			print " File: " . $i->{'file'};
			print " Line: " . $i->{'line'};
			print " Pos: " . $i->{'pos'};
		}

		print "\n";
	}

	return 1;
}

sub process_line {
	my ($line, $c, $file) = @_;
	my $len = length($line) - 1;
	my $x = 0;

	while($x < $len) {
		my $char = substr($line,$x,1);
		my $f = $startchars{$char};
		my $done = 0;
		my $sub;

		while (!$done && $f) {
			$sub = substr($line,$x,$f);

			if (exists($terminals{$sub})) {
				$done = 1;
				add_node($sub,$file, $c, $x);
				$x = $x + $f;
			} else {
				$f = $f - 1;
			}
		}

		if (!$done) {
			print "Warning at line: $c unknown terminal at $x\n";
			print "$line\n";
			add_node($sub, $file, $c, $x);
		}
			
	}
	add_node($EOL,$file, $c, $x);

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
	while(<$fh>) {
		my $line = $_;
		$num = $num + 1;

		if (!process_line($line, $num, $file)) {
			$error = $error + 1;
		}
	}
	add_node($EOF,$file, $num, 0);

	return $error;
}

sub print_terminal_info {
	my $t=0;
	my $c=0;

	print "\nCalling: print_terminal_info()\n";

	foreach my $i (keys %terminals) {
		$t = $t + 1;
		if ($terminals{$i} > 1) {
			print "Error Duplicate Terminal \"$i\" : " .
				$terminals{$i} . "\n";
		} elsif ($Options{'debug'}) {
			print "Terminal \"$i\" : $terminals{$i}\n";
		}
	}

	print "\n";

	foreach my $i (keys %startchars) {
		$c = $c + 1;
		if ($startchars{$i} > 1) {
			print "Startchars \"$i\" : $startchars{$i}\n";
		} elsif($Options{'debug'}) {
			print "Startchars \"$i\" : $startchars{$i}\n";
		}
	}

	print "\nTerminals: $t startchars = $c\n";
	return $c;
}

sub parse_tokens {
	my $c = 0;
	my $len = $#tokens;

	while ($c < $len) {

# XXX do the work here;
		return 1;
	}
}

sub main {
	GetOptions(\%Options, "debug");

	if ($#ARGV < 0) {
		usage();
		return 1;
	}
	if ($Options{"debug"}) {
		print "EOF is set to: $EOF\n";
		print "EOL is set to: $EOL\n";
	}

	if (!load_terminals("terminals.txt")) {
		return 1;
	}

	print_terminal_info();

	foreach my $i (@ARGV) {
		process_file($i);
	}

	if ($Options{"debug"}) {
		print "\ncalling: print_nodes()\n";
		print_nodes();
	}

	parse_tokens();

	return 0;
}

main();
