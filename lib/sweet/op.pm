package op;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	my @values = ("|", "-", "!", "#", "\$", "\%", "&", "(", ")", "*", "+",
		",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "\@", "[", "]",
		"^", "`", "{", "|", "}", "~", "\\");

	debug("op::starts");
	foreach my $i (@values) {
		if ( match($i)) {
			return 1;
		}
	}
	return 0;
}

sub valid {
}

sub get {
	my ($p, $l) = (query_stat('columnnum'), query_stat('linenum'));
	my $op = "";
	my $doneop;

	# Make sure larger ops defined first
	my @multiop = (">>=", "<<=",
		"!=", "==", "||", ">=", "<=", "++", "--", "&&", ">>", "<<", "+=",
		"-=", "*=", "/=", "%=", "&=", "|=", "^=", "?:", "->", "::", "<-",
		"!!", "=~", "=~", "..");

	push_scope();
	debug("op::get");

	if (!starts()) {
		pop_scope();
		return 0;
	}

	foreach my $i (@multiop) {
		if (match($i)) {
			my $x = 0;
			while ($x < length($i)) {
				$op = $op . get_char();
				$x = $x + 1;
				$doneop = 1;
			}
		}
	}
	if (!$doneop) {
		$op = get_char();
	}
	debug("op::get: $op");
	add_token("op", $op, $p, $l);
	add_stat("op", $op, 1);

	pop_scope();
	return 1;
}

sub put {
	my ($node) = @_;

	if ($node->{'type'} eq 'op') {
		return $node->{"value"};
	}
	return "";
}

1;
