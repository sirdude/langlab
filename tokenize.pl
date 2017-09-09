#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use LangLab::Parser;
use LangLab::Symbols;

use Getopt::Long;

my (@tokens, @parse_tokens, %rules, %Options);

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

	if (Symbols::is_terminal($tmp)) {
		$Symbols::terminals{$tmp} = $Symbols::terminals{$tmp} + 1;
	} else {
		$Symbols::terminals{$tmp} = 1;
	}

	if (is_startchar($first)) {
		my $r = Symbols::get_startchar($first);
		if ($r < $l) {
			Symbols::set_startchar($first, $l);
		}
	} else {
		Symbols::set_startchar($first, $l);
	}

	return 1;
}

sub add_rule {
	my ($lhs, @rhs) = @_;

	if ($Options{"debug"}) {
		print "add_rule($lhs";
		foreach my $t (@rhs) {
			print ", $t";
		}
		print ")\n";
	}

	# XXX Need to do work here

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

	if ($tok eq $Symbols::EOF) {
		$node->{"type"} = $Symbols::EOF;
	} elsif ($tok eq $Symbols::EOL) {
		$node->{"type"} = $Symbols::EOL;
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
		my $f = Symbols::get_startchar($char);
		my $done = 0;
		my $sub;

		while (!$done && $f) {
			$sub = substr($line,$x,$f);

			if (Symbols::is_terminal($sub)) {
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

			$sub = substr($line,$x,1);
			add_node($sub, $file, $c, $x);
			$x = $x + 1;
		}
			
	}
	add_node($Symbols::EOL,$file, $c, $x);

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

	close($fh);

	add_node($Symbols::EOF,$file, $num, 0);

	return $error;
}

sub print_terminal_info {
	my $t=0;
	my $c=0;

	print "\nCalling: print_terminal_info()\n";

	foreach my $i (keys %Symbols::terminals) {
		$t = $t + 1;
		if ($Symbols::terminals{$i} > 1) {
			print "Error Duplicate Terminal \"$i\" : " .
				$Symbols::terminals{$i} . "\n";
		} elsif ($Options{'debug'}) {
			print "Terminal \"$i\" : $Symbols::terminals{$i}\n";
		}
	}

	print "\n";

	foreach my $i (keys %Symbols::startchars) {
		$c = $c + 1;
		if (Symbols::get_startchar($i) > 1) {
			print "Startchars \"$i\" : " .
				Symbols::get_startchar($i) . "\n";
		} elsif($Options{'debug'}) {
			print "Startchars \"$i\" : " .
				Symbols::get_startchar($i) . "\n";
		}
	}

	print "\nTerminals: $t startchars = $c\n";
	return $c;
}

sub main {
	GetOptions(\%Options, "debug");

	if ($#ARGV < 0) {
		usage();
		return 1;
	}
	if ($Options{"debug"}) {
		print "EOF is set to: $Symbols::EOF\n";
		print "EOL is set to: $Symbols::EOL\n";
	}

	if (!Symbols::load_terminals("terminals.txt")) {
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

	@parse_tokens = Parser::parser_main(@tokens);

	return 0;
}

main();
