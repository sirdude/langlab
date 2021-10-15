#!/usr/bin/perl

use strict;
use warnings;

sub get_dir_files {
	my ($dir) = @_;
	if (opendir(my $DIRH, $dir)) {
		my @modules = grep !/^\.\.?$/, readdir $DIRH;
		close($DIRH);

		return @modules;
	} else {
		print "Unable to open directory $dir\n";
	}
	return "";
}

sub load_module {
	my ($dir, $module_name) = @_;

	if (-d $dir) {
		if (-f "$dir/$module_name") {
			# use lib $dir;
			# use $module_name;
			return 1;
		}
	}
	return 0;
}

sub load_modules {
	my ($dir) = @_;
	my @files = get_module_files($dir);

	foreach my $i (@files) {
		load_module($dir, $i);
	}
}

sub main {
	my @input = get_dir_files("./input");
	my @output = get_dir_files("./output");
	my @trans = get_dir_files("./transform");

	print "Input options:\n";
	foreach my $i (@input) {
		print "\t$i";
	}
	print "\n";

	print "Output options:\n";
	foreach my $i (@output) {
		print "\t$i";
	}
	print "\n";

	print "Transform options:\n";
	foreach my $i (@trans) {
		print "\t$i";
	}
	print "\n";
}


main();
