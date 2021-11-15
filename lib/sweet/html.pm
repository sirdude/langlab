package html;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	debug("html::starts");
	if ($ast->match('&#')) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my $word = "";
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});
	my $tmp;

	push_scope();
	debug("html::get");

	if (!starts()) {
		return 0;
	}

	while (!match(get_eof()) && (!match(";"))) {
		$tmp = get_char();
		$word = $word . $tmp;
	}
	$tmp = get_char();
	$word = $word . $tmp;

	if ($word =~ /&#\d+;/) {
		debug("html::get found: $word");
		add_stat("literal", "html", 1);
		add_token("html", $word, $p, $l);
		pop_scope();
		return 1;
	}
	error("html::get: " . $word . ", expected: &#DDDD;");
	pop_scope();
	return 0;
}

sub put {
	my (%node) = @_;

	if ($node->{'type'} eq 'html') {
		return $node->{"value"};
	}
	return "";
}

1;
