#!/usr/bin/perl
use strict;
use warnings;

my @NODES;
my $EOL = 111111111111111;
my $EOF = 222222222222222;

sub usage {
	print "$0: [FILENAMES | STR]\n";
	print "Parses the given list of files or considers input a string and parses that.\n";
	print "\n";

	return 1;
}

sub add_node {
	my ($data) = @_;
	my $node = {};

	if ($data eq $EOF) {
		$node->{'type'} = 'EOF';
		$node->{'data'} = 'NIL';
	} elsif ($data eq $EOL) {
		$node->{'type'} = 'EOL';
		$node->{'data'} = 'NIL';
	} else {
		$node->{'type'} = 'char';
		$node->{'data'} = $data;
	}
	push(@NODES, $node);

	return 1;
}

sub print_nodes {
	my $c = 0;

	foreach my $i (@NODES) {
		print "Node: $c\n";
		print "\t" . $i->{'type'} . "\n";
		print "\t" . $i->{'data'} . "\n";
		$c = $c + 1;
	}
	return 1;
}

sub nodes_to_json {
	my $start = 0;
	print "{ \"NODES\": [\n";
	foreach my $i (@NODES) {
		if (!$start) {
			$start = 1;
		} else {
			print ",\n";
			print '{ ' . $i->{'type'} . ', ' .
				$i->{'data'} . ' }';	
		}
		
	}
	if ($start) {
		print "\n";
	}
	print "] }\n";

	return 1;
}

sub nodes_to_xml {
	my $start = 0;
	print "<nodes>\n";
	foreach my $i (@NODES) {
	print "\t<node>\n";
	print "\t\t<type>" . $i->{'type'} . "</type>\n";
	print "\t\t<data>" . $i->{'data'} . "</data\n";
	print "\t</node>\n";
	}
	print "</nodes>\n";

	return 1;
}

sub parse_string {
	my ($string) = @_;

	foreach my $i (split //, $string) {
		if ($i eq "\n") {
			add_node($EOL);
		} else {
			add_node($i);
		}
	}
	return 1;
}

sub is_xml_file {
	my ($infile) = @_;
	my $end = length($infile);
	my $start = $end - 4;
	

	if (($start > 0) && substr($infile, $start, $end) eq ".xml") {
		return 1;
	}
	return 0;
}

sub is_json_file {
	my ($infile) = @_;
	my $end = length($infile);
	my $start = $end - 5;

	if (($start > 0) && substr($infile, $start, $end) eq ".json") {
		return 1;
	}
	return 0;
}

sub read_xml_file {
	my ($infile) = @_;
}

sub read_json_file {
	my ($infile) = @_;
}

sub parse_file {
	my ($fname) = @_;
	my $fh;

	if (is_xml_file($fname)) {
		return read_xml_file($fname);
	}
	if (is_json_file($fname)) {
		return read_json_file($fname);
	}

	if (open($fh, "<", $fname)) {
		while (<$fh>) {
			my $line = $_;
			parse_string($line);
		}
		close($fh);
		add_node($EOF);
		return 1;
	} else {
		return 0;
	}
}

sub get_usage_type {
	my @values = @_;
	my $tmp = 1;

	if (-f $values[0]) {
		foreach my $i (@values) {
			if (!parse_file($i)) {
				print "Error parsing file $i\n";
				$tmp = 0;
			}
		}
		return $tmp;
	} else {
		my $str = join(' ', @values);
		return parse_string($str);
	}
}

if (!@ARGV) {
	usage();
} else {
	get_usage_type(@ARGV);
#	print_nodes();
#	nodes_to_json();
	nodes_to_xml();
}
