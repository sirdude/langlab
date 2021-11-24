package tok_html;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	$ast->debug("html::starts");
	if ($ast->match('&#')) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast) = @_;
	my $word = "";
	my ($p, $l) = ($ast->query_stat('columnnum'), $ast->query_stat('linenum'));
	my $tmp;

	$ast->push_scope();
	$ast->debug("html::get");

	if (!start($ast)) {
		return 0;
	}

	while (!$ast->match(get_eof()) && (!$ast->match(";"))) {
		$tmp = get_char();
		$word = $word . $tmp;
	}
	$tmp = get_char();
	$word = $word . $tmp;

	if ($word =~ /&#\d+;/) {
		$ast->debug("html::get found: $word");
		$ast->add_stat("literal", "html", 1);
		add_token("html", $word, $p, $l);
		$ast->pop_scope();
		return 1;
	}
	error("html::get: " . $word . ", expected: &#DDDD;");
	$ast->pop_scope();
	return 0;
}

sub put {
	my ($node) = @_;

	if ($node->{'type'} eq 'html') {
		return $node->{"value"};
	}
	return "";
}

1;
