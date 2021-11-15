#!/usr/bin/perl
use strict;
use warnings;

use lib "../lib";
use options;

my (@NODES, %STATS);
my $EOL = 111111111111111;
my $EOF = 222222222222222;
my $linenum;

sub usage {
	print "$0: [OPTIONS] [FILENAMES | STR]\n";
	print "Parses the given list of files or considers input a string and parses that.\n";
	print "Converts input to a tree of nodes of characters and computes stats for the inputs as well.\n";
	print "\n";

	print_options();

	return 1;
}

sub debug {
	my ($info) = @_;

	if (query_option('debug')) {
		print "$info\n";
	}
}

sub add_node {
	my ($data) = @_;
	my $node = {};

	if ($data eq $EOF) {
		$node->{'type'} = 'EOF';
		$node->{'data'} = 'NIL';
		add_stat('char','EOF', 1);
	} elsif ($data eq $EOL) {
		$node->{'type'} = 'EOL';
		$node->{'data'} = 'NIL';
		add_stat('char', 'EOL', 1);
	} else {
		$node->{'type'} = 'char';
		$node->{'data'} = $data;
		add_stat('char', $data, 1);
	}
	add_stat('stats', 'totalchars', 1);
	push(@NODES, $node);

	return 1;
}

sub print_nodes {
	my $c = 0;

	foreach my $i (@NODES) {
		print "Node: $c\n";
		foreach my $key (sort keys %{$i}) {
			print "\t" . $key . ': ' . $i->{$key} . "\n";
		}
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
		}
		print '{ ';
			foreach my $key (sort keys %{$i}) {
				print "\t" . $key . ":" . $i->{$key} . ",\n";
			}
		print ' }';
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
	foreach my $key (sort keys %{$i}) {
		print "\t\t<$key>" . $i->{$key} . "</$key>\n";
	}
	print "\t</node>\n";
	}
	print "</nodes>\n";

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

sub get_xml_header {
	my ($fhh) = @_;

	my $header = <$fhh>;
	$linenum = 1;
	chomp $header;
	if ($header eq "<nodes>") {
		return 1;
	}

	return 0;
}

sub get_xml_node {
	my ($fhh) = @_;
	my $node = {};

	my $row = <$fhh>;
	chomp $row;
	$linenum += 1;
	if ($row =~ /\t<node>/) {
		$row = <$fhh>;
		chomp $row;
		$linenum += 1;
		while ($row ne "\t</node>") {
			if ($row =~ /<(.*)>(.*)<\/(.*)>/) {
				my $tag = $1;
				my $value = $2;
				$node->{$tag} = $value;
				$row = <$fhh>;
				chomp $row;
				$linenum += 1;
			} else {
				print "Error reading line $linenum: $row\n";
				return 0;
			}
		}
		if ($row eq "\t</node>") {
			push(@NODES, $node);
			return 1;
		}
		
	} elsif ($row eq "</nodes>") {
		return 2;
	}
	return 0;
}

sub read_xml_file {
	my ($infile) = @_;
	my ($fh, $done);

	if (open($fh, "<", $infile)) {
		if (get_xml_header($fh)) {
			$done = 1;
			while($done == 1) {
				$done = get_xml_node($fh);
			}
			close($fh);
			if ($done == 2) {
				return 1;
			}
		} else {
			close($fh);
		}
	}
	return 0;
}

sub get_json_header {
	my ($fhh) = @_;

	my $header = <$fhh>;
	$linenum = 1;
	chomp $header;
	if ($header eq "{ \"NODES\": [") {
		return 1;
	}

	return 0;
}

sub get_json_node {
	my ($fhh) = @_;
	my $node = {};

	my $row = <$fhh>;
	chomp $row;
	$linenum += 1;
	if ($row =~ /^{\s+(.*):(.*),/) {
		while ($row !~ /^\s*}(,?)/) {
			if ($row =~ /\s+(.*):(.*)(,?)/) {
				my $tag = $1;
				my $value = $2;
				$node->{$tag} = $value;
				$row = <$fhh>;
				chomp $row;
				$linenum += 1;
			} else {
				print "Error reading line $linenum: $row\n";
				return 0;
			}
		}
		if (($row =~ /^\s*}(,?)/)) {
			push(@NODES, $node);
			return 1;
		}
		
	} elsif ($row eq "] }") {
		return 2;
	}
	return 0;
}

sub read_json_file {
	my ($infile) = @_;
	my ($fh, $done);

	if (open($fh, "<", $infile)) {
		if (get_json_header($fh)) {
			$done = 1;
			while($done == 1) {
				$done = get_json_node($fh);
			}
			close($fh);
			if ($done == 2) {
				return 1;
			}
		} else {
			close($fh);
		}
	}
	return 0;
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

sub parse_file_or_string {
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

sub write_stats {
	my ($statfile) = @_;
	my ($sfh);

	debug("write_stats");
	open($sfh,">>", $statfile) or die
		"Unable to open stats file: $statfile\n";
	if ($sfh) {
		foreach my $i (sort keys %STATS) {
			if ($i eq "whitespace:\n") {
				print $sfh "whitespace:\\n:" . $STATS{$i} . "\n";
			} elsif ($i eq "whitespace:\r") {
				print $sfh "whitespace:\\r:" . $STATS{$i} . "\n";
			} elsif ($i eq "whitespace:\t") {
				print $sfh "whitespace:\\t:" . $STATS{$i} . "\n";
			} else {
				print $sfh "$i:" . $STATS{$i} . "\n";
			}
		}
		close ($sfh);
		return 1;
	}
	return 0;
}

sub add_stat {
	my ($stype, $skey, $svalue) = @_;

	debug("add_stat: $stype: $skey: $svalue");
	my $tmp = $stype . ":" . $skey;
	if (exists($STATS{$tmp})) {
		$STATS{$tmp} = $STATS{$tmp} + $svalue;
	} else {
		$STATS{$tmp} = $svalue;
	}
	return 1;
}

sub set_stat {
	my ($stype, $skey, $svalue) = @_;

	debug("add_stat: $stype: $skey: $svalue");
	my $tmp = $stype . ":" . $skey;
	$STATS{$tmp} = $svalue;
	return 1;
}

sub query_stat {
	my ($stype, $name) = @_;

	my $tmp = $stype . ":" . $name;
	return $STATS{$tmp};
}

sub clear_stats {
	%STATS = ();
}

sub main {
	my @VALUES = @_;
	my $ret = 0;

	add_option("help", "Print usage statement.");
	add_option("debug", "Enable debugging mode.");
	add_option("xml", "Use xml format for output.");
	add_option("json", "Use json format for output.");

	if (!@VALUES) {
		return usage();
	}

	@VALUES = parse_options(@VALUES);
	if (query_option('help')) {
		return usage();
	}

	if (parse_file_or_string(@VALUES)) {
		if (query_option('json')) {
			$ret = nodes_to_json();
		} elsif (query_option('xml')) {
			$ret = nodes_to_xml();
		} else {
			$ret = print_nodes();
		}
		write_stats("char_stats.txt");
	}
	return $ret;
}

main(@ARGV);
