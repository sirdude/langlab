#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;

my (%Options);

my (@chars, %startchar, %endchar);

sub usage {
	print "Usage: read_file filename\n\n";

	print "Reads in a file and creates a datastructure of the ";
	print "symbols with extra\ninformation.  ";
	print "Then it writes two new files, the first recreates the\n";
	print "original file.  ";
	print "The second prints out the internal datastructure.\n\n";

	return 1;
}

sub add_commenttype {
	my ($startc, $endc) = @_;

	if ($Options{"debug"}) {
		print "Adding comment start: $startc end: $endc\n";
	}

	if (exists($startchar{$startc})) {
		print "Error An entry for $startc: $startchar{$startc} " .
			" endchar: $endchar{$startc} already exists.\n";
		return 0;
	} else {
		$startchar{$startc} = "comment";
		$endchar{$startc} = $endc;
		return 1;
	}
}

sub add_stringtype {
	my ($startc, $endc) = @_;

	if ($Options{"debug"}) {
		print "Adding string start: $startc end: $endc\n";
	}
	if (exists($startchar{$startc})) {
		print "Error An entry for $startc: $startchar{$startc} " .
			" endchar: $endchar{$startc} already exists.\n";
		return 0;
	} else {
		$startchar{$startc} = "string";
		$endchar{$startc} = $endc;
		return 1;
	}
}

sub read_config {
	my ($infile) = @_;
	my ($fh, @values);
        my $c = 0;

	open($fh,"<","$infile") or die "Unable to open $infile\n";
	while(<$fh>) {
		my $line = $_;
                $c = $c+ 1;

		if ($Options{"debug"}) {
			print "read_config: Looking at line $c: $line\n";
		}

		chomp $line;

		if ($line =~ /^#(.*)/) {
		} elsif ($line =~ /^comment,(.*)$/) {
			@values = split(',', $line);
			add_commenttype($values[1],$values[2]);
		} elsif ($line =~ /^string,(.*)$/) {
			@values = split(',', $line);
			add_stringtype($values[1],$values[2]);
		} else {
			print "Error line $c: $line";
		}
	}

	return 1;
}

sub make_node {
	my ($value, $type, $infile, $line, $pos) = @_;
	my $node;

	$node->{'value'} = $value;
	$node->{'type'} = $type;
	$node->{'file'} = $infile;
	$node->{'line'} = $line;
	$node->{'pos'} = $pos;

	return $node;
}

sub read_input {
	my ($infile) = @_;
	my ($fh, $count, $type, $linen);

	if (!open($fh, "<", $infile)) {
		print "Unable to open $infile for reading.\n";
		return 0;
	}

	$linen = 0;
	while(<$fh>) {
		my ($line) = $_;
		chomp $line;
		my $len = length($line);

		$linen = $linen + 1;
		$count = 0;
		$type = 'char';

		while($count < $len) {
			my $i = substr($line, $count, 1);
			my $tnode = make_node($i, $type, $infile, $linen,
				$count);
			push(@chars, $tnode);
			$count = $count + 1;
		}

		my $tnode = make_node("EOL", "EOL", $infile, $linen, $count);
		push(@chars, $tnode);
		$count = $count + 1;
		
	}

	close($fh);

	return $count;
}

sub write_input {
	my ($outfile) = @_;
	my $fh;

	if (!open($fh, ">", $outfile)) {
		print "Unable to open $outfile for writing.\n";
		return 0;
	}

	foreach my $i (@chars) {
		if ($i->{'type'} eq "EOL") {
			print $fh "\n";
		} elsif ($i->{'type'} eq "EOF") {
			# Skip it...
		} else {
			print $fh $i->{'value'};
		}
	}

	close($fh);

	return 1;
}

sub write_next_input {
	my ($outfile) = @_;
	my ($fh);

	if (!open($fh, ">", $outfile)) {
		print "Unable to open $outfile for writing\n";
		return 0;
	}


	print $fh Dumper(@chars);

	close($fh);
	return 1;
}

sub get_new_name {
	my ($infile) = @_;
	my $ri = rindex($infile,'.');

	if ($ri > 1) {
		my $newname = substr($infile,0,$ri) . "_new.bnf";
		return $newname;
	}

	return "";
}

sub get_next_name {
	my ($infile) = @_;

	my $ri = rindex($infile,'.');

	if ($ri > 1) {
		my $newname = substr($infile,0,$ri) . ".chr";
		return $newname;
	}

	return "";
}

GetOptions(\%Options, "debug", "help");

my ($infile) = @ARGV;
if (!$infile || $Options{'help'}) {
	usage();
	exit(1);
}

if (!read_config("read_file.conf")) {
	exit(1);
}

if (!read_input($infile)) {
	exit(1);
}

my $newfile = get_new_name($infile);
if (!write_input($newfile)) {
	exit(1);
}

$newfile = get_next_name($infile);
if (!write_next_input($newfile)){
	exit(1);
}
