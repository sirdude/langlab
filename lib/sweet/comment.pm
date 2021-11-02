package comment;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(starts valid get);

sub starts {
	debug("comment::starts");
	if (match('/*') || match('#') || match('//')) {
		return 1;
	}
	return 0;
}

sub valid {
}

sub get {
	my ($com, $tmp) = ("", "");
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});

	$SPACES = $SPACES + 1;
	debug('comment::get Buf: ' . $buf);

	if (!starts()) {
		return 0;
	}

	if (match("//") || match("#")) {
		while (!match("\n") && !match(get_eof())) {
			$tmp = get_char();
			$com = $com . $tmp;
		}

		debug("single comment = '$com'");
		add_stat("comment","singleline", 1);
		add_token("comment", $com, $p, $l);

		$SPACES = $SPACES - 1;
		return 1;
	} else { # get /* */
		while (!match("*/") && !match(get_eof())) {
			$tmp = get_char();
			$com = $com . $tmp;
		}

		if (!match(get_eof())) { # Eat the end of comment '*/'
			$tmp = get_char();
			$com = $com . $tmp;
			$tmp = get_char();
			$com = $com . $tmp;
		}
		debug("double comment = '$com'");
		add_stat("comment", "multiline", 1);
		add_token("comment", $com, $p, $l);

		$SPACES = $SPACES - 1;
		return 1;
	}
	$SPACES = $SPACES - 1;
	return 0;
}

sub put {
	my (%node) = @_;

	if (($node->{'type'} eq 'comment') ||
		($node->{'type'} eq 'multicomment')) {
		return $node->{"value"};
	}
	return "";
}

1;
