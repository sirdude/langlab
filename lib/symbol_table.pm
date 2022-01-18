package symbol_table;

use warnings;
use base 'Exporter';

sub new {
	my $class = shift;
	my $self = {};

	bless $self, $class;

	$self->{'symtable'} = ();

	return $self;
}

sub clear {
	my ($self) = @_;

	$self->{'symtable'} = ();
}

# Simple symbol table functions
sub lookup_value {
	my ($self, $var) = @_;

	if (exists($self->{'symtable'}{$var})) {
		return $self->{'symtable'}{$var}->{'value'};
	}

	return "";
}

sub lookup_type {
	my ($self, $var) = @_;

	if (exists($self->{'symtable'}{$var})) {
		return $self->{'symtable'}{$var}->{'type'};
	}
	return '';
}

sub intable {
	my ($self, $var) = @_;

	if (exists($self->{'symtable'}{$var})) {
		$self->{'symtable'}{$var}->{'count'} = $self->{'symtable'}{$var}->{'count'} + 1;
		return 1;
	}

	return 0;
}

sub insert_symbol {
	my ($self, $sym, $type, $val) = @_;
	my %tmp;

#	debug('insert_symbol: Sym: ' . $sym . ' Type: ' .
#		$type . ' Val: ' . $val);

	if (intable($sym)) {
		error('Duplicate entry: ' . $sym);
		return 0;
	}

	$tmp{'value'} = $val;
	$tmp{'type'} = $type;
	$tmp{'count'} = 1;
	$self->{'symtable'}{$sym} = \%tmp;

	return 1;
}

sub dump_table {
	my ($self, $tmp, $val);

	print "Symbol Table Dump:\n";
	foreach my $i (keys %{$self->{'symtable'}}) {
		$tmp = $self->{'symtable'}{$i};

		if (exists($tmp->{'value'})) {
			$val = $tmp->{'value'};
		} else {
			$val = 'null';
		}

		if ($tmp->{'type'} eq 'keyword') {
			print '\tSymbol: ' . $i . ': type: ' . $tmp->{'type'} .
				" count: " . $$tmp->{'count'} . "\n";
		} else {
			print "\tSymbol: " . $i . ': type: ' . $tmp->{'type'} .
				' value: ' . $val . ' count: ' . $tmp->{'count'} .
				"\n";
		}
	}
	print "\n\n";

	return 1;
}

1;
