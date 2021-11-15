package whitespace;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	debug("whitespace::starts");
	if ($ast->match("\n") || $ast->match("\t") || $ast->match(' ') || $ast->match("\r")) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	push_scope();
	debug("whitespace::get");
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});

	if (!starts()) {
		pop_scope();
		return 0;
	}

	my $tmp = get_char();
	my $word = $tmp;

	if ($tmp eq " ") {
		add_stat("whitespace", 'SPACE', 1);
	} else {
		add_stat("whitespace", $tmp, 1);
	}

	while(match(" ") || match("\t") || match("\n") || match("\r")) {
		$tmp = get_char();
		$word = $word . $tmp;

		if ($tmp eq " ") {
			add_stat("whitespace", 'SPACE', 1);
		} else {
			add_stat("whitespace", $tmp, 1);
		}
	}
	add_token("whitespace", $word, $p, $l);
	debug("whitespace::get added '$tmp\' length:" . length($tmp) . "\n");

	pop_scope();
	return 1;
}

sub put {
	my (%node) = @_;

	if (!valid(%node))) {
		return $node->{"value"};
	}
	return "";
}

1;
