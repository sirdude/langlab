package ast;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(new add_node parse_file_or_string $EOL $EOF);

my $ast;
our $EOL = '__YY_EOL___';
our $EOF = '__YY_EOF___';
my $linenum;                        # Used for xml and json reading/debugging messages.

sub new {
	$ast = {};
	$ast->{'size'} = 0;
	$ast->{'head'} = 0;
	$ast->{'current'} = 0;
	$ast->{'tmp'} = 0;
	$ast->{'data'} = ();
	$ast->{'stats'} = ();

	return $ast;
}

sub peek {
	return $ast->{'data'}[$ast->{'current'}];
}

sub match {
	my ($str) = @_;
}

sub add_node {
	my ($data) = @_;
	my $node = {};

	$ast->{'size'} += 1;
	if ($data eq $EOF) {
		$node->{'type'} = 'EOF';
		$node->{'data'} = 'NIL';
		add_stat('char', 'EOF', 1);
	} elsif ($data eq $EOL) {
		$node->{'type'} = 'EOL';
		$node->{'data'} = 'NIL';
		add_stat('char', 'EOL', 1);
	} else {
		$node->{'type'} = 'char';
		$node->{'data'} = $data;
		add_stat('char', $data, 1);
	}
	$node->{'linenum'} = query_stat('stats', 'linenum');
	$node->{'columnnum'} = query_stat('stats','columnnum');
	add_stat('stats', 'totalchars', 1);
	push(@{$ast->{'data'}}, $node);
	if (($data eq $EOL) ) {
		add_stat('stats', 'linenum', 1);
		set_stat('stats', 'columnnum', 1);
	} else {
		add_stat('stats', 'columnnum');
	}

	return 1;
}

sub print_nodes {
	my $c = 0;

	foreach my $i (@{$ast->{'data'}}) {
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
	foreach my $i (@{$ast->{'data'}}) {
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
	foreach my $i (@{$ast->{'data'}}) {
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
			push(@{$ast->{'data'}}, $node);
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
			push(@{$ast->{'data'}}, $node);
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

sub add_stat {
	my ($stype, $skey, $svalue) = @_;

	debug("add_stat: $stype: $skey: $svalue");
	my $tmp = $stype . ":" . $skey;
	if (exists($ast->{'stats'}->{$tmp})) {
		$ast->{'stats'}->{$tmp} = $ast->{'stats'}->{$tmp} + $svalue;
	} else {
		$ast->{'stats'}->{$tmp} = $svalue;
	}
	return 1;
}

sub set_stat {
	my ($stype, $skey, $svalue) = @_;

	debug("add_stat: $stype: $skey: $svalue");
	my $tmp = $stype . ":" . $skey;
	$ast->{'stats'}->{$tmp} = $svalue;

	return 1;
}

sub query_stat {
	my ($stype, $name) = @_;

	my $tmp = $stype . ":" . $name;
	return $ast->{'stats'}->{$tmp};
}

sub clear_stats {
	$ast->{'stats'} = ();
	return 1;
}

sub write_stats {
	my ($statfile) = @_;
	my ($sfh);

	debug("write_stats");
	open($sfh,">>", $statfile) or die
		"Unable to open stats file: $statfile\n";
	if ($sfh) {
		foreach my $i (sort keys %{$ast->{'stats'}}) {
			if ($i eq "whitespace:\n") {
				print $sfh "whitespace:\\n:" . $ast->{'stats'}->{$i} . "\n";
			} elsif ($i eq "whitespace:\r") {
				print $sfh "whitespace:\\r:" . $ast->{'stats'}->{$i} . "\n";
			} elsif ($i eq "whitespace:\t") {
				print $sfh "whitespace:\\t:" . $ast->{'stats'}->{$i} . "\n";
			} else {
				print $sfh "$i:" . $ast->{'stats'}->{$i} . "\n";
			}
		}
		close ($sfh);
		return 1;
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

1;
