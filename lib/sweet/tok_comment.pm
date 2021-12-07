package tok_comment;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(start valid get);

sub start {
	my ($ast) = @_;
	$ast->debug('comment::start');
	if ($ast->match('/*') || $ast->match('#') || $ast->match('//')) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($ast, $outast) = @_;
	my ($com, $tmp) = ('', '');
	my ($p, $l) = $ast->get_loc();

	$ast->push_scope();
	$ast->debug('comment::get Buf: ' . $ast->peek());

	if (!start($ast)) {
		return 0;
	}

	if ($ast->match('//') || $ast->match('#')) {
		while (!$ast->match('\n') && !$ast->match($ast->get_eof())) {
			$tmp = $ast->consume();
			$com = $com . $tmp;
		}

		$ast->debug("single comment = '$com'");
		$ast->add_stat('comment', 'singleline', 1);
		$outast->add_node('comment', $com, $l, $p);

		$ast->pop_scope();
		return 1;
	} else { # get /* */
		while (!$ast->match('*/') && !$ast->match($ast->get_eof())) {
			$tmp = $ast->consume();
			$com = $com . $tmp;
		}

		if (!$ast->match($ast->get_eof())) { # Eat the end of comment '*/'
			$tmp = $ast->consume();
			$com = $com . $tmp;
			$tmp = $ast->consume();
			$com = $com . $tmp;
		}
		$ast->debug("double comment = '$com'");
		$ast->add_stat('comment', 'multiline', 1);
		$outast->add_node('comment', $com, $l, $p);

		$ast->pop_scope();
		return 1;
	}
	$ast->pop_scope();
	return 0;
}

sub put {
	my ($node) = @_;

	if (($node->{'type'} eq 'comment') ||
		($node->{'type'} eq 'multicomment')) {
		return $node->{'value'};
	}
	return '';
}

1;
