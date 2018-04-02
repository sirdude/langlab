#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my (%Options);

sub usage {
	print "Usage: $0 (infile.opt)\n";
	print "Reads in an optomized ast datafile and outputs the following:\n";
	print "\tA copy of it 'infile_new.opt' verifying that we read it " .
		"correctly.\n";
	print "\tinput_new.pl - new stage 1 based on our new " .
		"specifications.\n";
	print "\ttokenizer_new.pl - new stage 2 based on our new " .
		"specifications.\n";
	print "\tastwriter_new.pl - new stage 3 based on our new " .
		"specifications.\n";
	print "\tastwriter_new.pl - new stage 3 based on our new " .
		"specifications.\n";
	print "\toutput_new.pl - new replacement for this file.\n";
	print "\tstats_new.pl - new stats file.\n";

	return 1;
}

sub write_new_programs {
	if (!write_input_pl("input_new.pl")) {
		return 0;
	}
	if (!write_tokenizer_pl("tokenizer_new.pl")) {
		return 0;
	}
	if (!write_astwriter_pl("astwriter_new.pl")) {
		return 0;
	}
	if (!write_output_pl("output_new.pl")) {
		return 0;
	}
	return write_stats_pl("stats_new.pl");
}

sub process_input {
	my ($line) = @_;

	return 1;
}

sub write_input_pl {
	my ($filename) = @_;
	my ($fh, $tmp, $template);

	$tmp = "template/input.tmp";

	unlink ($filename);
	open($fh, ">", $filename) or die "Unable to open $filename\n";
	open($template, "<", $tmp) or die "Unable to open $tmp\n";

	while(<$template>) {
		my $line = $_;

		$line = process_input($line);
		print $fh $line;
	}
	close ($template);
	close ($fh);

	return 1;
}

sub process_tokenizer {
	my ($line) = @_;

	return 1;
}

sub write_tokenizer_pl {
	my ($filename) = @_;
	my ($fh, $tmp, $template);

	$tmp = "template/tokenizer.tmp";

	unlink ($filename);
	open($fh, ">", $filename) or die "Unable to open $filename\n";
	open($template, "<", $tmp) or die "Unable to open $tmp\n";

	while(<$template>) {
		my $line = $_;

		$line = process_tokenizer($line);
		print $fh $line;
	}
	close ($template);
	close ($fh);

	return 1;
}

sub process_astwriter {
	my ($line) = @_;

	return 1;
}

sub write_astwriter_pl {
	my ($filename) = @_;
	my ($fh, $tmp, $template);

	$tmp = "template/astwriter.tmp";

	unlink ($filename);
	open($fh, ">", $filename) or die "Unable to open $filename\n";
	open($template, "<", $tmp) or die "Unable to open $tmp\n";

	while(<$template>) {
		my $line = $_;

		$line = process_astwriter($line);
		print $fh $line;
	}
	close ($template);
	close ($fh);

	return 1;
}

sub process_output {
	my ($line) = @_;

	return 1;
}

sub write_output_pl {
	my ($filename) = @_;
	my ($fh, $tmp, $template);

	$tmp = "template/output.tmp";

	unlink ($filename);
	open($fh, ">", $filename) or die "Unable to open $filename\n";
	open($template, "<", $tmp) or die "Unable to open $tmp\n";

	while(<$template>) {
		my $line = $_;

		$line = process_output($line);
		print $fh $line;
	}
	close ($template);
	close ($fh);

	return 1;
}

sub process_stats {
	my ($line) = @_;

	return 1;
}

sub write_stats_pl {
	my ($filename) = @_;
	my ($fh, $tmp, $template);

	$tmp = "template/stats.tmp";

	unlink ($filename);
	open($fh, ">", $filename) or die "Unable to open $filename\n";
	open($template, "<", $tmp) or die "Unable to open $tmp\n";

	while(<$template>) {
		my $line = $_;

		$line = process_stats($line);
		print $fh $line;
	}
	close ($template);
	close ($fh);

	return 1;
}

sub read_input {
	my ($infile) = @ARGV;

}

sub write_input {
	my ($infile) = @ARGV;
}

my ($infile) = @ARGV;
if (!$infile) {
	usage();
	exit(1);
}

read_input($infile);
write_input($infile);
write_new_programs($infile);
