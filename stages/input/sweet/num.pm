package num;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(starts valid get);

sub starts {
	debug("num::starts");
	my @values = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
	foreach my $i (@values) {
		if (match($i)) {
			return 1;
		}
	}
	return 0;
}

sub valid {
}

sub get {
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});
	my $word;

	$SPACES = $SPACES + 1;
	debug("num::get:");

	if (!starts()) {
		return 0;
	}

	$word = get_char();
	while (starts()) {
		$word = $word . get_char();
	}
	if (match("..")) {
		debug("num::get $word");
		add_stat("num", "int", 1);
		add_token("int", $word, $p, $l);
		$SPACES = $SPACES - 1;
		return 1;
	} elsif (match(".")) {
		$word = $word . get_char();
		while (starts()) {
			$word = $word . get_char();
		}
		debug("num::get $word");
		add_stat("num", "float", 1);
		add_token("float", $word, $p, $l);
		$SPACES = $SPACES - 1;
		return 1;
	}
	debug("num::get $word");
	add_stat("num", "int", 1);
	add_token("int", $word, $p, $l);
	$SPACES = $SPACES - 1;
	return 1;
}

sub put {
	my (%node) = @_;

	if ($node->{'type'} eq 'int') {
		return $node->{"value"};
	}
	if ($node->{'type'} eq 'float') {
		return $node->{"value"};
	}
	return "";
}

1;
