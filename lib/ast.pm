package ast;

use strict;
use warnings;

our $EOL = '__YY_EOL___';
our $EOF = '__YY_EOF___';

# XXX Need to get rid of at least linenum???
my ($linenum);

sub new {
	my $class = shift;
	my $self = {};

	$self->{'current'} = 0;
	$self->{'size'} = 0;
	$self->{'scope'} = 0;
		
	bless $self, $class;
	return $self;
}

sub set_debug {
	my ($self, $debug) = @_;

	$self->{'debug'} = $debug;
	return $debug;
}

sub debug {
	my ($self, $info) = @_;

	if ($self->{'debug'}) {
		print "$info\n";
		return 1;
	}
	return 0;
}

sub push_scope {
	my ($self) = @_;

	$self->{'scope'} = $self->{'scope'} + 1;

	return $self->{'scope'};
}

sub pop_scope {
	my ($self) = @_;

	$self->{'scope'} = $self->{'scope'} - 1;

	return $self->{'scope'};
}

sub get_scope {
	my ($self) = @_;

	return $self->{'scope'};
}

# Look at just the next token
sub peek {
	my ($self, $count) = @_;

	if (!$count || $count eq '') {
		$count = 0;
	}
	$self->debug("ast::peek($count)\n");
	$count += $self->{'current'};
	if ($self->{'data'}[$count]->{'type'} eq 'EOF') {
		return $EOF;
	} elsif ($self->{'data'}[$count]->{'type'} eq 'EOL') {
		return $EOL;
	} else {
		return $self->{'data'}[$count]->{'data'};
	}
}

sub get_loc {
	my ($self) = @_;
	return ($self->{'data'}[$self->{'current'}]->{'linenum'},
		$self->{'data'}[$self->{'current'}]->{'columnnum'});
}

sub get_eof {
	return $EOF;
}

sub at_eof {
	my ($self) = @_;

	if ($self->{'current'} > $self->{'size'}) {
		return 1;
	}

	if ($self->{'data'}[$self->{'current'}]->{'type'} eq 'EOF') {
		return 1;
	}

	return 0;
}

# See if STR is a match to the next few tokens.
sub match {
	my ($self, $str) = @_;
	my $c = 1;
	my $tmp = $self->peek();
	if ($str) {
		while (length($tmp) < length($str)) {
			$tmp .= $self->peek($c);
			$c += 1;
		}
	}
	$self->debug("ast::match($str) tmp = $tmp");
	if ($tmp eq $str) {
		return 1;
	}
	return 0;
}

# Get the next token, if STR consume tokens until STR is fully consumed.  If not error.
sub consume {
	my ($self, $str) = @_;
	if (!$str || $str eq '') {
		my $pos = $self->{'current'};
		$self->{'current'} = $pos + 1;
		$str = '';
		$self->debug("ast::consume($str):" . $self->{'data'}[$pos]);
		return $self->{'data'}[$pos];
	} else {
		my $pos = $self->{'current'};
		$self->debug("ast::consume($str):" . $self->{'data'}[$pos]);
		my $tmp = $self->{'data'}[$pos];
		while (length($tmp) < length($str)) {
			$pos = $pos + 1;
			$tmp += $self->{'data'}[$pos];
		}
		$self->{'current'} = $pos + 1;
		$self->debug("ast::consume($str):" . $tmp);
		return $tmp;
	}
}

sub add_node {
	my ($self, $type, $data, $line, $column) = @_;
	my $node = {};

	$self->debug("ast::add_node($type, $data, $line, $column)\n");
	$self->{'size'} += 1;
	$node->{'type'} = $type;
	$node->{'data'} = $data;
	$node->{'linenum'} = $line;
	$node->{'columnnum'} = $column;

	if ($data eq $EOF) {
		$self->add_stat('char', 'EOF', 1);
	} elsif ($data eq $EOL) {
		$self->add_stat('char', 'EOL', 1);
	} else {
		$self->add_stat($type, $data, 1);
	}
	$self->add_stat('stats', 'totalchars', 1);
	push(@{$self->{'data'}}, $node);

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

	$self->debug("add_stat: $stype: $skey: $svalue");
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

	$self->debug("set_stat: $stype: $skey: $svalue");
	my $tmp = $stype . ":" . $skey;
	$self->{'stats'}->{$tmp} = $svalue;

	return 1;
}

sub query_stat {
	my ($self, $stype, $name) = @_;

	my $tmp = $stype . ":" . $name;
	$self->debug("query_stat($tmp) = " . $self->{'stats'}->{$tmp});
	return $self->{'stats'}->{$tmp};
}

sub clear_stats {
	my ($self) = @_;

	$self->debug("ast::clear_stats()");
	$self->{'stats'} = ();
	return 1;
}

sub write_stats {
	my ($self, $statfile) = @_;
	my ($sfh);

	$self->debug("write_stats");
	open($sfh,">>", $statfile) or die
		"Unable to open stats file: $statfile\n";
	if ($sfh) {
		foreach my $i (sort keys %{$self->{'stats'}}) {
			if ($i eq "whitespace:\n") {
				print $sfh "whitespace:\\n:" .
					$self->{'stats'}->{$i} . "\n";
			} elsif ($i eq "whitespace:\r") {
				print $sfh "whitespace:\\r:" .
					$self->{'stats'}->{$i} . "\n";
			} elsif ($i eq "whitespace:\t") {
				print $sfh "whitespace:\\t:" .
					$self->{'stats'}->{$i} . "\n";
			} elsif ($i eq "char:\t") {
				print $sfh "char:TAB(\\t):" .
					$self->{'stats'}->{$i} . "\n";
			} elsif ($i eq "char: ") {
				print $sfh "char:SPACE:" .
					$self->{'stats'}->{$i} . "\n";
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
	my ($self, $string, $lnum) = @_;
	my $c = 0;

	foreach my $i (split //, $string) {
		$c = $c + 1;
		if ($i eq "\n") {
			$self->add_node('EOL', $EOL, $lnum, $c);
		} else {
			$self->add_node('char', $i, $lnum, $c);
		}
	}
	return 1;
}

sub parse_file {
	my ($self, $fname) = @_;
	my $fh;
	my $l = 0;

	if (is_xml_file($self, $fname)) {
		return read_xml_file($self, $fname);
	}
	if (is_json_file($self, $fname)) {
		return read_json_file($self, $fname);
	}

	if (open($fh, "<", $fname)) {
		while (<$fh>) {
			my $line = $_;
			$l = $l + 1;
			parse_string($self, $line, $l);
		}
		close($fh);
		$l = $l + 1;
		$self->add_node('EOF', $EOF, $l, 0);
		$self->add_stat('stats', 'linenum', $l);
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
