package whitespace;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	$ast->debug("whitespace::starts");
	if ($ast->match("\n") || $ast->match("\t") || $ast->match(' ') || $ast->match("\r")) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast) = @_;
	my ($p, $l) = ($ast->query_stat('columnnum'), $ast->query_stat('linenum'));

	push_scope();
	$ast->debug("whitespace::get");

	if (!starts()) {
		pop_scope();
		return 0;
	}

	my $tmp = get_char();
	my $word = $tmp;

	if ($tmp eq " ") {
		$ast->add_stat("whitespace", 'SPACE', 1);
	} else {
		$ast->add_stat("whitespace", $tmp, 1);
	}

	while($ast->match(" ") || $ast->match("\t") || $ast->match("\n") || $ast->match("\r")) {
		$tmp = get_char();
		$word = $word . $tmp;

		if ($tmp eq " ") {
			$ast->add_stat("whitespace", 'SPACE', 1);
		} else {
			$ast->add_stat("whitespace", $tmp, 1);
		}
	}
	add_token("whitespace", $word, $p, $l);
	$ast->debug("whitespace::get added '$tmp\' length:" . length($tmp) . "\n");

	pop_scope();
	return 1;
}

sub put {
	my ($node) = @_;

	if (!valid($node)) {
		return $node->{"value"};
	}
	return "";
}

1;
