package tok_html;

use strict;
use warnings;

sub start {
	my ($ast) = @_;
	$ast->debug('html::start');
	if ($ast->match('&#')) {
		return 1;
	}
	return 0;
}

sub is_num {
	my ($check) = @_;

	my @values = ('1', '2', '3', '4', '5', '6', '7', '8', '9', '0');
	foreach my $i (@values) {
		if ($check eq $i) {
			return 1;
		}
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

	$tmp = $ast->consume('&#');
	while (is_num($ast->peek())) {
		$tmp = $ast->consume();
		$word .= $tmp;
	}
	if ($ast->match(';')) {
		$tmp = $ast->consume();
		$word .= $tmp;
		$ast->debug("html::get found: $word");
		$ast->add_stat('literal', 'html', 1);
		$outast->add_base_node('html', $word, $l, $p);
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
