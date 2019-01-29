#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;

my (%Options);

my @chars, @config;

sub usage {
	print "Usage: read_file filename\n\n";

	print "Reads in a file and creates a datastructure of the ";
	print "symbols with extra\ninformation.  ";
	print "Then it writes two new files, the first recreates the\n";
	print "original file.  ";
	print "The second prints out the internal datastructure.\n\n";
}

sub read_config {
	my $fh;
	open($fh,"<","read_file.conf") or die "Unable to open read_file.conf\n";
	while(<$fh>) {
		my $line = $_;
		if ($line =~ /^#(.*)/) {
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
