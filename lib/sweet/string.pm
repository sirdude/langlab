package string;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	$ast->debug("string::starts");
	if ($ast->match('"') || $ast->match("'")) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast) = @_;
	my ($p, $l) = ($ast->query_stat('columnnum'), $ast->query_stat('linenum'));
	my $type;

	my $tmp = "";
	my $lastchr = "";
	my $word = "";

	push_scope();
	$ast->debug("string::get: ");

	if (!starts()) {
		pop_scope();
		return 0;
	}

	$type = get_char();

	while (!$ast->match(get_eof()) && !$ast->match($type)) {
		$tmp = get_char();
		if ($tmp eq "\\") { # We have an escape read the next char as
					# well and treat it as one symbol...
			$tmp = $tmp . get_char();
		}
		$word = $word . $tmp;
		$lastchr = $tmp;
	}
	$ast->debug("string::get: string = $word");
	$ast->add_stat("string", $type, 1);
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
