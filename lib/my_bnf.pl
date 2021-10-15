#!/usr/bin/perl

use warnings;

use lib ".";
use options;

# We don't have any currently may want to set "entrypoint" or something similar
@keywords = ();

# Used to test rule with an input
# example usage test_rule("getreturn","return(5);");
sub test_rule {
	my ($rule, $input) = @_;

	$filename = '';
	open_output("./test_output.o");
	init_backend(@keywords);
	set_eof('^F');
	set_debug(1);
	$parsestring = $input;

	# prime our reading of the string.
	get_char();
	nextchar();

	close_output();
	return &$rule();
}

sub validate_keywords {
	my $warns = 0;

	foreach my $i (@keywords) {
		my $l = length $i;
		my $c = 0;

		foreach my $x (@keywords) {
			if ($i eq $x) {
				$c = $c + 1;
				if ($c > 1) {
					warning("keyword $i defined multiple " .
						"times.");
					$warns = $warns + 1;
				}
			} elsif (length($x) > $l) {
				if (substr($x, 0, $l) eq $i) {
					warning("keywords $i, $x overlap make " .
						"sure $x comes first in " .
						"defines.");
					$warns = $warns + 1;
				}
			}
		}
	}

	return $warns;
}

sub common_follows {
	my ($first, $sec) = @_;
	my @comm = ("()", "])", "))", "][", ")[", ");", "((", ")->",
		"),", "];", "]->", "({", "})", "++;", "++)", "--;", "--)",
		"(!", "!(", "..]", "[..", "**,", "**)", "],");

	my $str = "$first$sec";
	foreach my $i (@comm) {
		if ($i eq $str) {
			return 1;
		}
	}
	return 0;
}


sub is_keyword {
	my ($in) = @_;

	foreach my $i (@keywords) {
		if ($i eq $in) {
			return 1;
		}
	}
	return 0;
}

sub parser {
	$SPACES = $SPACES + 1;
	debug('parser:');

	while(!match(get_eof())) {
		nextchar();

		# This is the entrance point to our grammar
		# which is defined in our bnf...
		# YY_get_syntax();
	}
	$SPACES = $SPACES - 1;

	return 1;
}

sub YY_start_comment {
	debug("YY_start_comment");
	if (match('/*') || match('#') || match('//')) {
		return 1;
	}
	return 0;
}

sub YY_start_whitespace {
	debug("YY_start_whitespace");
	if (match("\n") || match("\t") || match(' ') || match("\r")) {
		return 1;
	}
	return 0;
}

sub YY_start_string {
	debug("YY_start_string");
	if (match('"') || match("'")) {
		return 1;
	}
	return 0;
}

sub YY_start_html {
	debug("YY_start_html");
	if (match('&#')) {
		return 1;
	}
	return 0;
}

sub YY_start_hex {
	debug("YY_start_hex");
	if (match('0x')) {
		return 1;
	}
	return 0;
}

sub YY_start_num {
	debug("YY_start_num");
	my @values = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
	foreach my $i (@values) {
		if (match($i)) {
			return 1;
		}
	}
	return 0;
}

sub YY_start_ident {
	# A-Z, a-z, _
	my @values = ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
		"L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
		"X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i",
		"j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u",
		"v", "w", "x", "y", "z", "_");
	
	debug("YY_start_ident");
	foreach my $i (@values) {
		if (match($i)) {
			return 1;
		}
	}
	return 0;
}

sub YY_start_op {
	my @values = ("|", "-", "!", "#", "\$", "\%", "&", "(", ")", "*", "+",
		",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "\@", "[", "]",
		"^", "`", "{", "|", "}", "~", "\\");

	debug("YY_start_op");
	foreach my $i (@values) {
		if ( match($i)) {
			return 1;
		}
	}
	return 0;
}

sub YY_valid_hex {
	my @values = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
		'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f');

	debug("YY_valid_hex");
	foreach my $i (@values) {
		if (match($i)) {
			return 1;
		}
	}
	return 0;
}

sub YY_get_comment {
	my ($com, $tmp) = ("", "");
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});

	$SPACES = $SPACES + 1;
	debug('YY_getcomment: Buf: ' . $buf);

	if (!YY_start_comment()) {
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

sub YY_get_whitespace {
	$SPACES = $SPACES + 1;
	debug("YY_get_whitespace");
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});

	if (!YY_start_whitespace()) {
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
	debug("YY_get_whitespace: added '$tmp\' length:" . length($tmp) . "\n");
	$SPACES = $SPACES - 1;
	return 1;
}

sub YY_get_string {
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});
	my $type;

	my $tmp = "";
	my $lastchr = "";
	my $word = "";

	$SPACES = $SPACES + 1;
	debug("YY_get_string: ");

	if (!YY_start_string()) {
		return 0;
	}

	$type = get_char();

	while (!match(get_eof()) && !match($type)) {
		$tmp = get_char();
		if ($tmp eq "\\") { # We have an escape read the next char as
					# well and treat it as one symbol...
			$tmp = $tmp . get_char();
		}
		$word = $word . $tmp;
		$lastchr = $tmp;
	}
	debug("YY_get_string: string = $word");
	add_stat("string", $type, 1);
	add_token("string", $word, $p, $l);
	# eat the end of string token...
	$tmp = get_char();

	$SPACES = $SPACES - 1;

	return 1;
}


sub YY_get_html {
	my $word = "";
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});
	my $tmp;

	$SPACES = $SPACES + 1;
	debug("YY_get_html");

	if (!YY_start_html()) {
		return 0;
	}

	while (!match(get_eof()) && (!match(";"))) {
		$tmp = get_char();
		$word = $word . $tmp;
	}
	$tmp = get_char();
	$word = $word . $tmp;

	if ($word =~ /&#\d+;/) {
		debug("YY_get_html found: $word");
		add_stat("literal", "html", 1);
		add_token("html", $word, $p, $l);
		$SPACES = $SPACES - 1;
		return 1;
	}
	error("YY_get_html: " . $word . ", expected: &#DDDD;");
	$SPACES = $SPACES - 1;
	return 0;
}

sub YY_get_hex {
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});
	my $word;

	$SPACES = $SPACES - 1;
	debug("YY_get_hex:");

	if (!YY_start_hex()) {
		return 0;
	}

	$word = get_char() . get_char(); # grab the 0x
	if (YY_valid_hex()) {
		$word = $word . get_char();
	} else {
		return 0;
	}

	if (YY_valid_hex()) {
		$word = $word . get_char();
	} else {
		return 0;
	}

	debug("YY_get_hex: $word");
	add_stat("literal", "hex", 1);
	add_token("hex", $word, $p, $l);
	$SPACES = $SPACES - 1;
	return 1;
}

sub YY_get_num {
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});
	my $word;

	$SPACES = $SPACES + 1;
	debug("YY_get_num:");

	if (!YY_start_num()) {
		return 0;
	}

	$word = get_char();
	while (YY_start_num()) {
		$word = $word . get_char();
	}
	if (match("..")) {
		debug("YY_get_num $word");
		add_stat("num", "int", 1);
		add_token("int", $word, $p, $l);
		$SPACES = $SPACES - 1;
		return 1;
	} elsif (match(".")) {
		$word = $word . get_char();
		while (YY_start_num()) {
			$word = $word . get_char();
		}
		debug("YY_get_num $word");
		add_stat("num", "float", 1);
		add_token("float", $word, $p, $l);
		$SPACES = $SPACES - 1;
		return 1;
	}
	debug("YY_get_num $word");
	add_stat("num", "int", 1);
	add_token("int", $word, $p, $l);
	$SPACES = $SPACES - 1;
	return 1;
}

sub YY_get_ident {
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});
	my $word;

	if (!YY_start_ident()) {
		return 0;
	}

	$word = get_char();

	debug("YY_get_ident: start = '$word'");
	$SPACES = $SPACES + 1;
	while (YY_start_num() || YY_start_ident()) {
		$word = $word . get_char();
	}
	debug("YY_get_ident: '$word'");
	if (is_keyword($word)) {
		add_stat("keyword", $word, 1);
	} else {
		if (query_option('names')) {
			add_stat("ident", $word, 1);
		} else {
			add_stat("ident", "ident", 1);
		}
	}
	add_token("ident", $word, $p, $l);
	$SPACES = $SPACES - 1;
	return 1;
}

sub YY_get_op {
	my ($p, $l) = ($stats{'columnnum'}, $stats{'linenum'});
	my $op = "";
	my $doneop;

	# Make sure larger ops defined first
	my @multiop = (">>=", "<<=",
		"!=", "==", "||", ">=", "<=", "++", "--", "&&", ">>", "<<", "+=",
		"-=", "*=", "/=", "%=", "&=", "|=", "^=", "?:", "->", "::", "<-",
		"!!", "=~", "=~", "..");

	$SPACES = $SPACES + 1;
	debug("YY_get_op:");

	if (!YY_start_op()) {
		return 0;
	}

	foreach my $i (@multiop) {
		if (match($i)) {
			my $x = 0;
			while ($x < length($i)) {
				$op = $op . get_char();
				$x = $x + 1;
				$doneop = 1;
			}
		}
	}
	if (!$doneop) {
		$op = get_char();
	}
	debug("YY_get_op: $op");
	add_token("op", $op, $p, $l);
	add_stat("op", $op, 1);

	$SPACES = $SPACES - 1;
	return 1;
}

sub eat_whitespace_comment {
	my ($index) = @_;

	while (($tokens[$index]->{'type'} eq "whitespace") ||
		($tokens[$index]->{'type'} eq "comment")) {
		$index = $index + 1;
	}

	return $index;
}

sub YY_get_statement {
	my ($pos) = @_;
}

sub YY_get_rule {
	my ($pos) = @_;
	$SPACES = $SPACES + 1;
	debug('YY_get_rule');
	$SPACES = $SPACES - 1;

	# ident = $tokens[$pos];
	$pos += 1;
	$pos = eat_whitespace_comment($pos);
	if ($tokens[$pos]->{'value'} ne "=") {
		error("Expected assignment operator in rule, got: " .
			$tokens[$pos]->{'value'} . " l: " .
			$tokens[$pos]->{'linenum'} . " p:" .
			$tokens[$pos]->{'posnum'});
		exit(1);
	}
	$pos = eat_whitespace_comment($pos);
	# XXX this needs work... where do we store statement and
	# how do we use it?
	$pos = YY_get_statement($pos);

	return $pos;
}

sub YY_get_syntax {
	$SPACES = $SPACES + 1;
	debug('YY_get_syntax:');
	my $x = 0;
	$maxx = sizeof(@tokens);

	my $t = $tokens[$x]->{"type"};
	while ($t ne "EOF") {
		if ($t eq "whitespace") {
			$x = $x + 1;
		} elsif ($t eq "comment") {
			$x = $x + 1;
		} elsif ($t eq "ident") {
			$x = YY_get_rule($x);
		} else {
			error("Expected rule, got: " . $t . ":l:" .
				$tokens[$x]->{"line"} . "p: " .
				$tokens[$x]->{"pos"});
		}

	}
	$SPACES = $SPACES - 1;
}

# This defines the major things that will show up in our code and
# is a function to get the next thing need to make sure there are no
# overlaps.... (if ident allows _wah _ can't be an operator...)
sub nextchar {
	$SPACES = $SPACES + 1;
	debug('nextchar:');

	if (match($EOF)) {
		# Nothing to do at end of file.
	} elsif (YY_start_comment()) {
		YY_get_comment();
	} elsif (YY_start_whitespace()) {
		YY_get_whitespace();
	} elsif (YY_start_ident()) {
		YY_get_ident();
	} elsif (YY_start_string()) {
		YY_get_string();
	} elsif (YY_start_html()) {
		YY_get_html();
	} elsif (YY_start_hex()) {
		YY_get_hex();
	} elsif (YY_start_num()) {
		YY_get_num();
	} elsif (YY_start_op()) {
		YY_get_op();
	} else {
		error('nextchar: invalid input: ' . $buf);
		return 0;
	}
	$SPACES = $SPACES - 1;

	return 1;
}

1;
