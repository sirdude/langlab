package tok_op;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	my @values = ("|", "-", "!", "#", "\$", "\%", "&", "(", ")", "*", "+",
		",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "\@", "[", "]",
		"^", "`", "{", "|", "}", "~", "\\");

	$ast->debug("op::starts");
	foreach my $i (@values) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast) = @_;
	my ($p, $l) = ($ast->query_stat('columnnum'), $ast->query_stat('linenum'));
	my $op = "";
	my $doneop;

	# Make sure larger ops defined first
	my @multiop = (">>=", "<<=",
		"!=", "==", "||", ">=", "<=", "++", "--", "&&", ">>", "<<", "+=",
		"-=", "*=", "/=", "%=", "&=", "|=", "^=", "?:", "->", "::", "<-",
		"!!", "=~", "=~", "..");

	$ast->push_scope();
	$ast->debug("op::get");

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	foreach my $i (@multiop) {
		if ($ast->match($i)) {
			my $x = 0;
			while ($x < length($i)) {
				$op = $op . $ast->consume();
				$x = $x + 1;
				$doneop = 1;
			}
		}
	}
	if (!$doneop) {
		$op = $ast->consume();
	}
	$ast->debug("op::get: $op");
	add_token("op", $op, $p, $l);
	$ast->add_stat("op", $op, 1);

	$ast->pop_scope();
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
