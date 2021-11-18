package string;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	debug("string::starts");
	if (match('"') || match("'")) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($p, $l) = (query_stat('columnnum'), query_stat('linenum'));
	my $type;

	my $tmp = "";
	my $lastchr = "";
	my $word = "";

	push_scope();
	debug("string::get: ");

	if (!starts()) {
		pop_scope();
		return 0;
	}

	$type = get_char();

	while (!match(get_eof()) && !match($type)) {
		$tmp = get_char();
		if ($tmp eq "\\") { # We have an escape read the next char as
					# well and treat it as one symbol...
			$tmp = $tmp . get_char();
		}
		$word = $word . $tmp;
		$lastchr = $tmp;
	}
	debug("string::get: string = $word");
	add_stat("string", $type, 1);
	add_token("string", $word, $p, $l);
	# eat the end of string token...
	$tmp = get_char();

	pop_scope();

	return 1;
}

sub put {
	my ($node) = @_;

	if ($node->{'type'} eq 'string') {
		return $node->{"value"};
	}
	return "";
}

1;
