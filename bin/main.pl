#!/usr/bin/perl
# Our program is broken up into 3 parts 
# this file	handles the commandline options	(GUI)
# backend.pm	has lowlevel functions that are generic
# my_bnf.pl	has our language specific code, loaded by load_backend

use strict;
use warnings;

use lib ('./lib');
use backend;
use options;

load_backend('./lib/my_bnf.pl');

sub usage {
	print "\tusage: $0 [Options] [FILENAME]\n\n";
	print "This application uses our reusable compiler code to build ";
	print "a translator from\n";
	print "standard bnf to the syntax we use internally.";
	print "  our second application will\n";
	print "translate the other direction.\n";
	print "\n";
	print "If filename is present load that file and parse it.  If not,\n";
	print "start excepting input from stdin, use ^F to exit.\n\n";

	print_options();

	return 1;
}

sub main {
	my $done = 0;

	add_option("debug", "Enable debugging mode.");
	add_option("help", "Print this usage message.");
	add_option("names", "Use ident names in stats not just the word ident.");
	add_option("output", "Set the output file.", "FILE");
	add_option("xml", "Use xml format for output");
	add_option("human", "Use a human readable format for output");
	add_option("json", "Use json format for output");

	set_eof('');

	@ARGV = parse_options(@ARGV);

	if (query_option('debug')) {
		set_debug(1);
	}

	if (query_option('help')) {
		return usage();
	}

	if (!query_option('output')) {
		set_option('output','a.out.c');
	}
	open_output(query_option('output'));

	init_backend(@keywords);

	debug('Begin Parsing.');

	foreach my $tfile (@ARGV) {
		print "Reading $tfile\n";
		read_compfile($tfile);
		$done = 1;
	}

	if (!$done) {
		print 'Entering interactive mode.Use ' . get_eof() .
			" to end.\n";
		read_compfile('');
	}

	close_output();

	debug('End Parsing.');

	if (query_option('json')) {
		print_tokens('json');
	} elsif (query_option('xml')) {
		print_tokens('xml');
	} else {
		print_tokens('human');
	}

	write_stats('stats.txt');

	return 1;
}

main();
