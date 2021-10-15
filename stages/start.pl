#!/usr/bin/perl

use strict;
use warnings;

# Need two functions for each type, is_blah and read_blah
#
sub is_xml_file {
	my ($fname) = @_;
	my $end = length($fname);
       	my $start = $end - 4;
	if (($start > 0) && substr($fname, $start, $end) eq ".xml") {
		return 1;
	}
	return 0;
}

sub is_json_file {
	my ($fname) = @_;
	my $end = length($fname);
       	my $start = $end - 5;
	if (($start > 0) && substr($fname, $start, $end) eq ".json") {
		return 1;
	}
	return 0;
}

parse_input {
	my ($input) = @_;

	# XXX Need to make this for each type if is_type then read_type
	if (-f $input) {
		if (is_xml_file($input)) {
			return read_xml($input);
		} elsif (is_json_file($input)) {
			return read_json($input);
		} elsif (is_human_file($input)) {
			return read_human($input);
		} else { # standard file
			return read_file($input);
		}
	} else {
		if ($input ne "") {
			return $input;
		} else { # read from cmdline
		}
	}
}


