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
}

sub write_new_programs {
	write_input_pl("input_new.pl");
	write_tokenizer_pl("tokenizer_new.pl");
	write_astwriter_pl("astwriter_new.pl");
	write_output_pl("output_new.pl");
	write_stats_pl("stats_new.pl");
}

sub write_input_pl {
	my ($filename) = @_;
	my $fh;

	unlink ($filename);
	open($fh, ">", $filename) or die "Unable to open $filename\n";

	print $fh "#!/usr/bin/perl\n";
	print $fh "\n";
	print $fh "use strict;\n";
	print $fh "use warnings;\n";
	print $fh "use Getopt::Long;\n";
	print $fh "\n";
	print $fh "my (%Options);\n";
	print $fh "\n";
	print $fh "sub usage {\n";
	print $fh "print \"Usage: \$0 (infile.opt)\\n\";\n";
	print $fh "}\n";
	print $fh "\n";

	print $fh "sub read_input {\n";
	print $fh "\tmy (\$infile) = \@_;\n";
	print $fh "}\n";
	print $fh "\n";

	print $fh "sub write_input {\n";
	print $fh "\tmy (\$infile) = \@_;\n";
	print $fh "}\n";
	print $fh "\n";

	print $fh "sub write_next_input {\n";
	print $fh "\tmy (\$infile) = \@_;\n";
	print $fh "}\n";
	print $fh "\n";

	print $fh "my (\$infile) = \@ARGV;\n";
	print $fh "if (!\$infile || ) {\n";
	print $fh "\tusage();\n";
	print $fh "\texit(1);\n";
	print $fh "}\n";
	print $fh "\n";

	print $fh "read_input(\$infile);\n";
	print $fh "write_input(\$infile);\n";
	print $fh "write_next_input(\$infile);\n";

	close($fh);
}

sub write_tokenizer_pl {
}

sub write_astwriter_pl {
}

sub write_output_pl {
# XXX Need to do the others first...
}

sub write_stats_pl {
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
