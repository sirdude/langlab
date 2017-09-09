package Symbols;

use strict;
use warnings;

our @EXPORT = qw(
	$EOF
	$EOL
	$TAB
	$NEWLINE
	load_terminals
	save_terminals
	is_terminal
	add_terminal
	is_startchar
	get_startchar
	set_startchar
	);

our $EOF = "EOF_XXX";
our $EOL = "EOL_XXX";
our $TAB = "\t";
our $NEWLINE = "\n";

our %terminals; 
our %startchars;

sub add_terminal {
	my ($tmp) = $_;

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

sub is_terminal {
	my ($arg) = @_;

	return exists($terminals{$arg});
}

sub load_terminals {
	my ($infile) = @_;
	my ($fh, $c);
	$c = 0;

	if (!open($fh, "<", $infile)) {
		print "Error could not read terminals from file: $infile\n";
		return 0;
	}

	while(<$fh>) {
		my $tline = chomp $_;
		$c = $c + 1;

		if (!add_terminal($tline)) {
			print "Error in read terminals at line: $c\n";
		}
	}
	close($fh);

	return 1;
}

sub save_terminals {
	my ($infile) = @_;
	my ($fh, $c);

	if (!open($fh, ">", $infile)) {
		print "Error could not write terminals to file: $infile\n";
		return 0;
	}

	$c = 0;
	foreach my $i (keys %terminals) {
		print $fh "$i\n";
		$c = $c +1;
	}

	close($fh);
	return 1;
}

sub is_startchar {
	my ($arg) = @_;

	return exists($startchars{$arg});
}

sub get_startchar {
	my ($arg) = @_;

	return $startchars{$arg};
}

sub set_startchar {
	my ($arg,$value) = @_;

	if (!$value) {
		print "ERROR: set_startchar called with out value\n";
		return 0;
	}

	$startchars{$arg} = $value;
	return 1;
}

1;
