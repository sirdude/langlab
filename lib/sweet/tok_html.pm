package tok_html;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	$ast->debug('html::start');
	if ($ast->match('&#')) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast, $outast) = @_;
	my $word = '';
	my ($p, $l) = $ast->get_loc();
	my $tmp;

	$ast->push_scope();
	$ast->debug('html::get');

	if (!start($ast)) {
		return 0;
	}

	while (!$ast->match($ast->get_eof()) && (!$ast->match(';'))) {
		$tmp = $ast->consume();
		$word .= $tmp;
	}
	$tmp = $ast->consume();
	$word .= $tmp;

	if ($word =~ /&#\d+;/) {
		$ast->debug("html::get found: $word");
		$ast->add_stat('literal', 'html', 1);
		$outast->add_node('html', $word, $l, $p);
		$ast->pop_scope();
		return 1;
	}
	print("ERROR: html::get: got $word, expected: &#DDDD;\n");
	$ast->pop_scope();
	return 0;
}

sub put {
	my ($node) = @_;

	if ($node->{'type'} eq 'html') {
		return $node->{'value'};
	}
	return '';
}

1;
