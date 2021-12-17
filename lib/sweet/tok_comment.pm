package tok_comment;

use strict;
use warnings;
use base 'Exporter';

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
	my ($ast, $outast, $keepws_flag) = @_;
	my ($com, $tmp) = ('', '');
	my ($p, $l) = $ast->get_loc();
	my $done = 0;

	$ast->push_scope();
	$ast->debug('comment::get Buf: ' . $ast->peek());

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

		if ($keepws_flag) {
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
		if ($keepws_flag) {
			$outast->add_base_node('comment', $com, $l, $p);
		}

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
