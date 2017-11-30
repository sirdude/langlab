package Tokens;

use strict;
use warnings;

use lib ".";
use lib "./LangLab";
use Symbols;

our @EXPORT = qw(
	valid_type
	read_tok_file
	write_tok_file
	write_file
	);

our @tokens;

sub valid_type {
	my ($input) = @_;

	if ($input eq "delimiter") {
		return 1;
	} elsif ($input eq "terminal") {
		return 1;
	} elsif ($input eq "string") {
		return 1;
	} elsif ($input eq "comment") {
		return 1;
	} elsif ($input eq "ident") {
		return 1;
	} elsif ($input eq "whitespace") {
		return 1;
	} elsif ($input eq "unknown") {
		return 1;
	}
	return 0;
}

sub make_node {
	my ($tok, $type, $file, $line, $pos) = @_;
	my $node;

# XXX How do we enable this now...
#	print "make_node($tok, $type, $file, $line, $pos)\n";

	$node->{"file"} = $file;
	$node->{"line"} = $line;
	$node->{"pos"} = $pos;
	$node->{"value"} = $tok;
	$node->{"type"} = $type;

	if (!valid_type($type)) {
		if ($tok eq $Symbols::EOF) {
			$node->{"type"} = "EOF";
		} elsif ($tok eq $Symbols::EOL) {
			$node->{"type"} = "EOL";
		} elsif ($tok =~ /#(.*)/) {
			$node->{"type"} = "comment";
		} elsif ($tok =~ /\"(.*)/) {
			$node->{"type"} = "string";
		} elsif ($tok =~ /\'(.*)/) {
			$node->{"type"} = "string";
		} else {
			$node->{"type"} = "token";
		}
	}

	return $node;
}


sub read_tok_file {
	my ($infile) = @_;
	my ($fh, $type, $value, $c);

	open($fh, "<", $infile) or
		die "Unable to open $infile for reading.\n";
	$c = 0;
	while(<$fh>) {
		my $line = $_;

		$c = $c + 1;

		if ($line =~ /^#(.*)/) {
			# Skip comments in our .tok file.
		} elsif ($line =~ /^$/) {
			# Skip blank lines in our .tok file.
		} elsif ($line =~ /^(\w+): (.*)$/) {
			$type = $1;
			$value = $2;

			if (!valid_type($type)) {
				print "Error line $c: invalid type $type\n";
			} else {
				my $node =
					make_node($value,$type,$infile,$c,0);
				push(@tokens, $node);
				
			}
		} else {
			print "Error line $c: $line\n";
		}
	}

	return 1;
}

sub write_tok_file {
	my ($outfile) = @_;
	my ($fh);

	open($fh, ">", $outfile) or 
		die "Unable to open $outfile for writing.\n";

	if (!$fh) {
		return 0;
	}
	foreach my $node (@tokens) {
		print $fh "make_node(" .$node->{"value"} . ", " .
			$node->{"type"} . ", " . 
			$node->{"file"} . ", " . 
			$node->{"line"} . ", " . 
			$node->{"pos"} . ")\n"; 
	}

	close($fh);

	return 1;
}

sub write_file {
	my ($outfile) = @_;
	my ($fh);

	open($fh, ">", $outfile) or 
		die "Unable to open $outfile for writing.\n";

	if (!$fh) {
		return 0;
	}
	foreach my $node (@tokens) {
		if ($node->{"type"} eq "EOF") {
			# We are done here don't print the symbol...
		} elsif ($node->{"type"} eq "EOL") {
			print $fh "\n";
		} else {
			print $fh $node->{"value"};
		}
	}

	close($fh);

	return 1;
}

1;
