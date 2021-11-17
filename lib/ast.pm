package ast;

sub new {
	my $class = shift;
	my $self = {};
		
	bless $self, $class;
	return $self;
}

our $EOL = '__YY_EOL___';
our $EOF = '__YY_EOF___';
my ($linenum, $debug);                        # Used for xml and json reading/debugging messages.

sub set_debug {
	($debug) = @_;

	return $debug;
}

sub debug {
	my ($info) = @_;

	if ($debug) {
		print "$info\n";
		return 1;
	}
	return 0;
}

sub peek {
	my ($self) = @_;

	return $self->{'data'}[$self->{'current'}];
}

sub match {
	my ($self, $str) = @_;
}

sub add_node {
	my ($self, $data) = @_;
	my $node = {};

	$self->{'size'} += 1;
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
	push(@{$self->{'data'}}, $node);
	if (($data eq $EOL) ) {
		add_stat('stats', 'linenum', 1);
		set_stat('stats', 'columnnum', 1);
	} else {
		add_stat('stats', 'columnnum');
	}

	return 1;
}

sub print_nodes {
	my ($self) = @_;
	my $c = 0;

	foreach my $i (@{$self->{'data'}}) {
		print "Node: $c\n";
		foreach my $key (sort keys %{$i}) {
			print "\t" . $key . ': ' . $i->{$key} . "\n";
		}
		$c = $c + 1;
	}
	return 1;
}

sub nodes_to_json {
	my ($self) = @_;
	my $start = 0;

	print "{ \"NODES\": [\n";
	foreach my $i (@{$self->{'data'}}) {
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
	my ($self) = @_;
	my $start = 0;

	print "<nodes>\n";
	foreach my $i (@{$self->{'data'}}) {
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
	my ($self, $infile) = @_;
	my $end = length($infile);
	my $start = $end - 4;

	if (($start > 0) && substr($infile, $start, $end) eq ".xml") {
		return 1;
	}
	return 0;
}

sub is_json_file {
	my ($self, $infile) = @_;
	my $end = length($infile);
	my $start = $end - 5;

	if (($start > 0) && substr($infile, $start, $end) eq ".json") {
		return 1;
	}
	return 0;
}

sub get_xml_header {
	my ($self, $fhh) = @_;

	my $header = <$fhh>;
	$linenum = 1;
	chomp $header;
	if ($header eq "<nodes>") {
		return 1;
	}

	return 0;
}

sub get_xml_node {
	my ($self, $fhh) = @_;
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
			push(@{$self->{'data'}}, $node);
			return 1;
		}
		
	} elsif ($row eq "</nodes>") {
		return 2;
	}
	return 0;
}

sub read_xml_file {
	my ($self, $infile) = @_;
	my ($fh, $done);

	if (open($fh, "<", $infile)) {
		if (get_xml_header($self, $fh)) {
			$done = 1;
			while($done == 1) {
				$done = get_xml_node($self, $fh);
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
	my ($self, $fhh) = @_;

	my $header = <$fhh>;
	$linenum = 1;
	chomp $header;
	if ($header eq "{ \"NODES\": [") {
		return 1;
	}

	return 0;
}

sub get_json_node {
	my ($self, $fhh) = @_;
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
			push(@{$self->{'data'}}, $node);
			return 1;
		}
		
	} elsif ($row eq "] }") {
		return 2;
	}
	return 0;
}

sub read_json_file {
	my ($self, $infile) = @_;
	my ($fh, $done);

	if (open($fh, "<", $infile)) {
		if (get_json_header($self, $fh)) {
			$done = 1;
			while($done == 1) {
				$done = get_json_node($self, $fh);
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
	my ($self, $stype, $skey, $svalue) = @_;

	debug("add_stat: $stype: $skey: $svalue");
	my $tmp = $stype . ":" . $skey;
	if (exists($self->{'stats'}->{$tmp})) {
		$self->{'stats'}->{$tmp} = $self->{'stats'}->{$tmp} + $svalue;
	} else {
		$self->{'stats'}->{$tmp} = $svalue;
	}
	return 1;
}

sub set_stat {
	my ($self, $stype, $skey, $svalue) = @_;

	debug("add_stat: $stype: $skey: $svalue");
	my $tmp = $stype . ":" . $skey;
	$self->{'stats'}->{$tmp} = $svalue;

	return 1;
}

sub query_stat {
	my ($self, $stype, $name) = @_;

	my $tmp = $stype . ":" . $name;
	return $self->{'stats'}->{$tmp};
}

sub clear_stats {
	my ($self) = @_;

	$self->{'stats'} = ();
	return 1;
}

sub write_stats {
	my ($self, $statfile) = @_;
	my ($sfh);

	debug("write_stats");
	open($sfh,">>", $statfile) or die
		"Unable to open stats file: $statfile\n";
	if ($sfh) {
		foreach my $i (sort keys %{$self->{'stats'}}) {
			if ($i eq "whitespace:\n") {
				print $sfh "whitespace:\\n:" . $self->{'stats'}->{$i} . "\n";
			} elsif ($i eq "whitespace:\r") {
				print $sfh "whitespace:\\r:" . $self->{'stats'}->{$i} . "\n";
			} elsif ($i eq "whitespace:\t") {
				print $sfh "whitespace:\\t:" . $self->{'stats'}->{$i} . "\n";
			} else {
				print $sfh "$i:" . $self->{'stats'}->{$i} . "\n";
			}
		}
		close ($sfh);
		return 1;
	}
	return 0;
}

sub parse_string {
	my ($self, $string) = @_;

	foreach my $i (split //, $string) {
		if ($i eq "\n") {
			add_node($self, $EOL);
		} else {
			add_node($self, $i);
		}
	}
	return 1;
}

sub parse_file {
	my ($self, $fname) = @_;
	my $fh;

	if (is_xml_file($self, $fname)) {
		return read_xml_file($self, $fname);
	}
	if (is_json_file($self, $fname)) {
		return read_json_file($self, $fname);
	}

	if (open($fh, "<", $fname)) {
		while (<$fh>) {
			my $line = $_;
			parse_string($self, $line);
		}
		close($fh);
		add_node($self, $EOF);
		return 1;
	} else {
		return 0;
	}
}

sub parse_file_or_string {
	my $self = shift;
	my @values = @_;
	my $tmp = 1;

	if (-f $values[0]) {
		foreach my $i (@values) {
			if (!parse_file($self, $i)) {
				print "Error parsing file $i\n";
				$tmp = 0;
			}
		}
		return $tmp;
	} else {
		my $str = join(' ', @values);
		return parse_string($self, $str);
	}
}

1;
