package tok_comment;

use strict;
use warnings;
use base 'Exporter';

sub start {
	my ($ast) = @_;
	$ast->debug('tok_comment::start');
	if ($ast->match('/*') || $ast->match('#') || $ast->match('//')) {
		return 1;
	}
	return 0;
}

sub get {
	my ($ast, $outast) = @_;
	my ($com, $tmp) = ('', '');
	my ($p, $l) = $ast->get_loc();
	my $done = 0;

	$ast->push_scope('tok_comment->get');
	$ast->debug($ast->get_hscope() . ' Buf: ' . $ast->peek());

	if (!start($ast)) {
		return 0;
	}

	if ($ast->match('//') || $ast->match('#')) {
		while (!$done && !$ast->match("\n")) {
		    if ($ast->match('EOF')) {
			    $done = 1;
			} else {
				$com = $com . $ast->consume();
			}
		}
		if ($ast->match("\n")) {
			$com = $com . $ast->consume();
		}

		$ast->debug("single comment = '$com'");
		$ast->add_stat('comment', 'singleline', 1);

		if ($ast->{'keep-ws'}) {
			$outast->add_base_node('comment', $com, $l, $p);
		}

		$ast->pop_scope();
		return 1;
	} else { # get /* */
		$tmp = $ast->consume('/*');
		$com = $com . $tmp;

		while (!$done && !$ast->match('*/')) {
			$tmp = $ast->consume();
			if ($tmp eq 'EOF') {
				$done = 1;
			} else {
				$com = $com . $tmp;
			}
		}

		if (!$ast->match('EOF')) { # Eat the end of comment '*/'
			$tmp = $ast->consume();
			$com = $com . $tmp;
			$tmp = $ast->consume();
			$com = $com . $tmp;
		}
		$ast->debug("double comment = '$com'");
		$ast->add_stat('comment', 'multiline', 1);
		if ($ast->{'keep-ws'}) {
			$outast->add_base_node('comment', $com, $l, $p);
		}

		$ast->pop_scope();
		return 1;
	}
	$ast->pop_scope();
	return 0;
}

1;
