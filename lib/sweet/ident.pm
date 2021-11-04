package ident;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	# A-Z, a-z, _
	my @values = ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
		"L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
		"X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i",
		"j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u",
		"v", "w", "x", "y", "z", "_");

	debug("ident::starts");
	foreach my $i (@values) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub starts_num {
	my ($ast) = @_;
	my @values = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9");
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
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});
	my $word;

	if (!starts()) {
		return 0;
	}

	$word = get_char();

	debug("ident::get: start = '$word'");
	$SPACES = $SPACES + 1;
	while (starts_num($ast) || starts($ast)) {
		$word = $word . get_char();
	}
	debug("ident::get: '$word'");
	if (is_keyword($word)) {
		add_stat("keyword", $word, 1);
	} else {
		if (query_option('names')) {
			add_stat("ident", $word, 1);
		} else {
			add_stat("ident", "ident", 1);
		}
	}
	add_token("ident", $word, $p, $l);
	$SPACES = $SPACES - 1;
	return 1;
}

sub put {
	my (%node) = @_;

	if ($node->{'type'} eq 'ident') {
		return $node->{"value"};
	}
	return "";
}

1;
