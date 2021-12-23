package ast;

use strict;
use warnings;

our $EOL = "\n";
our $EOF = '__YY_EOF___';

# XXX Need to get rid of at least linenum???
my ($linenum);

sub new {
	my ($class, $args) = @_;
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

sub error {
	my ($self, $info) = @_;

	print $self->{'data'}->{'current'}{'linenum'} . ':' .
		$self->{'data'}->{'current'}{'linenum'} . ':' .
		$info . "\n";
	return 1;
}

sub push_scope {
	my ($self) = @_;

	$self->{'scope'} = $self->{'scope'} + 1;

	return $self->{'scope'};
}

sub pop_scope {
	my ($self) = @_;

	$self->{'scope'} = $self->{'scope'} - 1;
	if ($self->{'scope'} < 0) {
		print "ERROR: Scope < 0\n";
	}

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

	if ($count >= $self->{'size'}) {
		return $EOF;
	} elsif ($self->{'data'}[$count]->{'type'} eq 'EOF') {
		$self->debug("Node: $count numnodes: " . $self->{'size'} .
			' Type ' . $self->{'data'}[$count]->{'type'} .
			' data ' . $self->{'data'}[$count]->{'data'} . "\n");
		return $EOF;
	} elsif ($self->{'data'}[$count]->{'type'} eq 'EOL') {
		$self->debug("Node: $count numnodes: " . $self->{'size'} .
			' Type ' . $self->{'data'}[$count]->{'type'} .
			' data ' . $self->{'data'}[$count]->{'data'} . "\n");
		return $EOL;
	} else {
		$self->debug("Node: $count numnodes: " . $self->{'size'} .
			' Type ' . $self->{'data'}[$count]->{'type'} .
			' data ' . $self->{'data'}[$count]->{'data'} . "\n");
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

	if ($self->{'current'} >= $self->{'size'}) {
		return 1;
	}

	if ($self->{'data'}[$self->{'current'}]->{'data'} eq $EOF) {
		return 1;
	}

	return 0;
}

sub show_invis {
	my ($tok) = @_;
	my %syms;

	$syms{' '} = ' ';
	$syms{"\t"} = '\t';
	$syms{"\n"} = '\n';
	$syms{"\r"} = '\r';

	if (exists($syms{$tok})) {
		return $syms{$tok};
	}
	return $tok;
}

# See if STR is a match to the next few tokens.
sub match {
	my ($self, $str) = @_;
	my $done = 0;
	my $c = 0;
	my $l = length($str);
	my $ans = '';

	$self->debug("ast::match($str)");
	
	if (($str eq 'EOF') && $self->at_eof()) {
		return 1;
	}

	while ($c < $l && !$done) {
		my $tmp = $self->peek($c);
		if ($tmp eq get_eof()) {
			$done = 1;
		} else {
			$ans .= $tmp;
		}
		$c = $c + length($tmp);
	}

	my $name = show_invis($str);
	my $name2 = show_invis($ans);

	$self->debug("ast::match($name) tmp = '$name2'");

	if ($str eq $ans) {
		return 1;
	}
	return 0;
}

sub match_type {
	my ($self, $type) = @_;

	if ($self->at_eof()) {
		if ($type eq 'EOF') {
			return 1;
		}
		return 0;
	}

	if ($self->{'data'}[$self->{'current'}]->{'type'} eq $type) {
		return 1;
	}
	return 0;
}

# Get the next token, if STR consume tokens until STR is fully consumed.  If not error.
sub consume {
	my ($self, $str) = @_;

	if ($self->at_eof()) {
		return 'EOF';
	}
	if (!$str || $str eq '') {
		my $pos = $self->{'current'};
		$self->{'current'} = $pos + 1;
		$str = '';
		$self->debug("ast::consume($str):" . $self->{'data'}[$pos]->{'data'});
		return $self->{'data'}[$pos]->{'data'};
	} else {
		my $l = length($str);
		my $pos = $self->{'current'};
		$self->debug("ast::consume($str):" . $self->{'data'}[$pos]->{'data'});
		my $tmp = $self->{'data'}[$pos]->{'data'};
		while (length($tmp) < $l) {
			$pos = $pos + 1;
			$tmp .= $self->{'data'}[$pos]->{'data'};
		}
		$self->{'current'} = $pos + 1;
		$self->debug("ast::consume($str):" . $tmp);
		return $tmp;
	}
}

sub add_base_node {
	my ($self, $type, $data, $line, $column) = @_;
	my $node = {};

	$self->debug("ast::add_base_node($type, $data, $line, $column)\n");
	$node->{'type'} = $type;
	$node->{'data'} = $data;
	$node->{'linenum'} = $line;
	$node->{'columnnum'} = $column;

    return add_node($self, $node);
}

sub add_node {
	my ($self, $node) = @_;

	if ($node->{'data'} eq $EOF) {
		$self->add_stat('char', 'EOF', 1);
	} elsif ($node->{'data'} eq $EOL) {
		$self->add_stat('char', 'EOL', 1);
	} else {
	    if (!$self->{'expand-stats'}) {
			if (($node->{'type'} eq 'string') || ($node->{'type'} eq 'comment') ||
				($node->{'type'} eq 'whitespace') || ($node->{'type'} eq 'ident')) {
					$self->add_stat($node->{'type'}, $node->{'type'}, 1);
				} else {
					$self->add_stat($node->{'type'}, $node->{'data'}, 1);
				}
		} else {
			$self->add_stat($node->{'type'}, $node->{'data'}, 1);
		}
	}
	$self->add_stat('stats', 'totalchars', 1);

	push(@{$self->{'data'}}, $node);
	$self->{'size'} += 1;

	return 1;
}

sub print_nodes {
	my ($self, $filename) = @_;
	my $c = 0;
	my $fh;

	if (($filename eq '') || ($filename eq '1')) {
		foreach my $i (@{$self->{'data'}}) {
			print "Node: $c\n";
			foreach my $key (sort keys %{$i}) {
				print "\t" . $key . ': ' . $i->{$key} . "\n";
			}
			$c = $c + 1;
		}
	} else {
		open($fh, ">", $filename) or die "Unable to open $filename\n";
		foreach my $i (@{$self->{'data'}}) {
			print $fh "Node: $c\n";
			foreach my $key (sort keys %{$i}) {
				print $fh "\t" . $key . ': ' . $i->{$key} . "\n";
			}
			$c = $c + 1;
	}
	}
	return 1;
}

sub nodes_to_json {
	my ($self, $filename) = @_;
	my $start = 0;
	my $fh;

	if (($filename eq '') || $filename == 1) {
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
	} else {
		open($fh, ">", $filename) or die "Unable to open $filename\n";
		print $fh "{ \"NODES\": [\n";
		foreach my $i (@{$self->{'data'}}) {
			if (!$start) {
				$start = 1;
			} else {
				print $fh ",\n";
			}
			print $fh '{ ';
				foreach my $key (sort keys %{$i}) {
					print $fh "\t" . $key . ":" . $i->{$key} . ",\n";
				}
			print $fh ' }';
		}
		if ($start) {
			print $fh "\n";
		}
		print $fh "] }\n";
	}

	return 1;
}

sub nodes_to_xml {
	my ($self, $filename) = @_;
	my $start = 0;
	my $fh;

	if (($filename eq '') || $filename == 1) {
		print "<nodes>\n";
		foreach my $i (@{$self->{'data'}}) {
			print "\t<node>\n";
			foreach my $key (sort keys %{$i}) {
				print "\t\t<$key>" . $i->{$key} . "</$key>\n";
			}
			print "\t</node>\n";
		}
		print "</nodes>\n";
	} else {
		open($fh, ">", $filename) or die "Unable to open $filename\n";
		print $fh "<nodes>\n";
		foreach my $i (@{$self->{'data'}}) {
			print $fh "\t<node>\n";
			foreach my $key (sort keys %{$i}) {
				print $fh "\t\t<$key>" . $i->{$key} . "</$key>\n";
			}
			print $fh "\t</node>\n";
		}
		print $fh "</nodes>\n";
	}

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
	if (exists($self->{'stats'}->{$tmp})) {
		$self->debug("query_stat($tmp) = " . $self->{'stats'}->{$tmp});
		return $self->{'stats'}->{$tmp};
	} else {
		$self->debug("query_stat($tmp) = ''");
		return '';
	}
}

sub clear_stats {
	my ($self) = @_;

	$self->debug("ast::clear_stats()");
	$self->{'stats'} = ();
	return 1;
}

sub write_stats {
	my ($self, $statfile) = @_;
	my ($sfh, %table);

	$table{"whitespace:\n"} = 'whitespace:\n:';
	$table{"whitespace:\r"} = 'whitespace:\r:';
	$table{"whitespace:\t"} = 'whitespace:\t:';
	$table{"char: "} = 'char:SPACE:';
	$table{"char:\t"} = 'char:\t:';

	$self->debug("write_stats");
	open($sfh,">>", $statfile) or die
		"Unable to open stats file: $statfile\n";
	if ($sfh) {
		foreach my $i (sort keys %{$self->{'stats'}}) {
			if (exists($table{$i})) {
				print $sfh $table{$i} . ':' . $self->{'stats'}->{$i} . "\n";
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

	$self->debug("parse_string:: $string, $lnum");

	foreach my $i (split //, $string) {
		$c = $c + 1;
		if ($i eq "\n") {
			$self->add_base_node('EOL', $EOL, $lnum, $c);
		} else {
			$self->add_base_node('char', $i, $lnum, $c);
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
			$self->parse_string($line, $l);
		}
		close($fh);
		$l = $l + 1;
		$self->add_base_node('EOF', $EOF, $l, 0);
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
		return $self->parse_string($str, 0);
	}
}

1;
