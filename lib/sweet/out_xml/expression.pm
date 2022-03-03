package expression;

use strict;
use warnings;
use Data::Dumper;

use const;
use ident;
use bracket;
use binop;
use unop;

sub is {
	my ($self) = @_;

	if ($self{'type'} eq 'expression') {
		return 1;
	}
	return 0;
}

sub output {
	my ($self, $data) = @_;

	$data .= "<expression>\n";

	if (unop::is($self->{'data'})) {
		$data .= "<unop>\n";
		$data .= "<type>" . $self->{'type'} . "</type>\n";
		if (!output:$self{'data'}, \$output) {
			return 0;
		}
		$data .= "</unop>\n";
	} elsif (binop::is($self->{'data'})) {
		$data .= "<unop>\n";
		$data .= "<type>" . $self->{'type'} . "</type>\n";
		$data .= "<lhs>";
		if (!ident::output($self{'lhs'}, \$output) {
			return 0;
		}
		$data .= "</lhs>\n";
		$data .= "<rhs>\n";
		if (!output:$self{'data'}, \$output) {
			return 0;
		}
		$data .= "</rhs>\n";
	} elsif (const::is($self->{'data'})) {
	# XXX do it..
	} elsif (ident::is($self->{'data'})) {
	# XXX do it..
	} else (bracket::is($self->{'data'})) {
	# XXX do it..
	} else {
		$self->error("Invalid expression: " . Dumper($self->{'data'}));
		return 0;
	}

	$data .= "</expression>\n";
	return 1;
}

1;
