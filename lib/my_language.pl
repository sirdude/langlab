use warnings;

# We don't have any currently may want to set "entrypoint" or something similar
@keywords = ('int', 'float', 'string', 'void', 'mixed',
                'mapping', 'object',
                'static', 'atomic', 'private', 'unsigned', 'nomask',
                'include', 'inherit', 'for', 'while', 'if', 'else',
                'switch', 'return', 'exit', 'break', 'case', 'default',
                'read', 'write', 'goto',);

# Should look at not hard coding these... XXX
my @comment_starts = ('#', '/', '-');
my @whitespace = (' ', "\t", "\r", "\n");
my @operator_starts = ('=', '|');

# This defines the major things that will show up in our code and
# is a function to get the next thing need to make sure there are no
# overlaps.... XXX if ident allows _wah _ can't be an operator...
sub nexttoken {
	$SPACES = $SPACES + 1;
	debug('nexttoken: look: ' . $look);

	if ($look eq $EOF) {
		$token = $EOF;
		$SPACES = $SPACES - 1;
	} elsif (in_set($look, @comment_starts)) {
		get_comment();
		$SPACES = $SPACES - 1;
		nexttoken(); # This is a token we want to skip...
	} elsif (in_set($look, @whitespace)) {
		YY_get_whitespace();
		$SPACES = $SPACES - 1;
		nexttoken(); # This is a token we want to skip...
	} elsif (YY_is_alpha($look)) {
		YY_get_ident();
		$SPACES = $SPACES - 1;
	} elsif (YY_is_digit($look)) {
		YY_get_num();
		$SPACES = $SPACES - 1;
	} elsif (YY_isquotes($look)) {
		YY_get_quotes($look);
	} elsif (in_set($look, @operator_starts)) {
		YY_get_op();
		$SPACES = $SPACES - 1;
	} else {
		error('nexttoken: invalid input: ' . $look);
		$SPACES = $SPACES - 1;
	}

	return $token;
}

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
	nexttoken();

	close_output();
	return &$rule();
}

sub parser {
	debug('parser: look: ' . $look . "\n");

	# We need to load look for nexttoken to work correctly.
	get_char();
	nexttoken();

	while($token ne $EOF) {
		if ($DEBUG) {
			print 'parser: Token: ' . $token . ' Value: ' . $value .
				' Look: ' . $look . "\n";
		}

		if (($value eq 'include') || ($value eq 'inherit')) {
			YY_get_include();
		} else {
			YY_get_def($value, ());
		}
	}
	return 1;
}

sub YY_get_comment {
	$SPACES = $SPACES + 1;
	debug('YY_get_comment: Look: ' . $look);
	$value = "";

	if ($look eq '#') {
		while ($look ne "\n") {
			$value = $value . $look;
			get_char();
		}
	} elsif ($look eq '-') {
		get_char();
		if ($look eq '-') {
			$value = '-';
			while ($look ne "\n") {
				$value = $value . $look;
				get_char();
			}
		} else {
			error("YY_get_comment found - expected --\n");
			$value = "-";
		}
	} elsif ($look eq '/') {
		get_char();
		if ($look eq '/') {
			$value = '/';
			while ($look ne "\n") {
				$value = $value . $look;
				get_char();
			}
		} elsif ($look eq "*") {
			get_char();
			my $lastlook = $look;
			$value = "/*";

			while (($lastlook ne '*') && ( $look ne '/')) {
				$value = $value . $look;
				$lastlook = $look;
				get_char();
			}
		} else {
			error("YY_get_comment: found / expected // or /*\n");
			$value = "/";
		}
	}
	emit($value);
	$SPACES = $SPACES - 1;
	return $value;
}

sub YY_get_whitespace {
	$value = "";
	$SPACES = $SPACES + 1;
	debug('YY_get_whitespace: Look: ' . $look);

	while(in_set($look, @whitespace)) {
		$value = $value . $look;
		get_char();
	}
	$token = "whitespace";

	debug('YY_get_whitespace: Token: ' . $token . ' Value: ' . $value);
	emit($value);
	$SPACES = $SPACES - 1;
	return $value;
}

sub YY_is_whitespace {
	my ($in) = @_;

	return in_set($in, @whitespace);
}

sub YY_is_type {
	my ($type) = @_;
	my @types = ('int', 'float', 'string', 'void', 'mixed', 'mapping', 'object');

	return in_set($type,@types);
}

sub YY_is_typemod {
	my ($mod) = @_;
	my @mods = ('static', 'atomic', 'private', 'unsigned', 'nomask');

	return in_set($mod, @mods);
}

sub YY_is_constant {
	my ($in) = @_;

	if (YY_is_string($in)) {
		return 1;
	}
	if ($token eq 'float') {
		return 1;
	}
	if ($token eq 'int') {
		return 1;
	}
	return 0;
}

sub YY_is_alpha {
	my ($chr) = @_;

	if (($chr ge 'a') && ($chr le 'z')) {
		return 1;
	} elsif (($chr ge 'A') && ($chr le 'Z')) {
		return 1;
	}

	return 0;
}

sub YY_is_digit {
	my ($chr) = @_;

	if ($chr =~ /(\d+)/) {
		return 1;
	}

	return 0;
}

sub YY_is_alphanum {
	my ($in) = @_;

	if (YY_is_digit($in)) {
		return 1;
	} elsif (YY_is_alpha($in)) {
		return 1;
	} elsif (($in eq '-') || ($in eq '_')) {
		return 1;
	}
	return 0;
}

sub YY_is_addop {
	my ($in) = @_;
	my @ops = ('+', '-');

	return in_set($in, @ops);
}

sub YY_is_multop {
	my ($in) = @_;
	my @ops = ('*', '/');

	return in_set($in, @ops);
}

sub YY_is_orop {
	my ($in) = @_;
	my @ops = ('|', '&');

	return in_set($in, @ops);
}
sub YY_is_relop {
	my ($in) = @_;
	my @ops = ('=', '!', '<', '>');

	return in_set($in, @ops);
}

sub YY_is_op {
	my ($in) = @_;
	my @ops = ('+', '-', '*', '/', '<', '>', '=', '!');

	return in_set($in, @ops);
}

sub YY_is_quotes {
	my ($in) = @_;

	if ($in eq "'") {
		return 1;
	} elsif ($in eq "\"") {
		return 1;
	}

	return 0;
}

sub YY_is_string {
	my ($in) = @_;

	if ($in eq 'float') {
		return 1;
	} elsif ($in eq 'int') {
		return 1;
	} elsif ($in eq 'string') {
		return 1;
	} else {
		my $ttt = lookup_type($in);
		if ($ttt eq 'string') {
			return 1;
		} elsif ($ttt eq 'float') {
			return 1;
		} elsif ($ttt eq 'int') {
			return 1;
		}
	}

	return 0;
}

sub YY_get_return {
	$SPACES = $SPACES + 1;
	debug('YY_get_return: Token:' . $token . ' Value: ' . $value . 
		' Look: ' . $look);
	nexttoken();
	matchstring('(');
	YY_get_num();
	matchstring(')');
	$SPACES = $SPACES - 1;
}

sub YY_get_type {
	$SPACES = $SPACES + 1;
	debug('YY_get_type: Token:' . $token . ' Value: ' . $value . 
		' Look: ' . $look);
	if (!YY_is_type($token)) {
		error("Expected type got $token line $linenum\n");
	}
	$SPACES = $SPACES - 1;
}

sub YY_get_block {
	$SPACES = $SPACES + 1;
	$tab = $tab + 1;
	if ($maxtab < $tab) {
		$maxtab = $tab;
	}

	debug('YY_get_block: Tabs: ' . $tab);
	matchstring('{');

	while (($token ne $EOF) && ($token ne '}')) {
		debug('YY_get_block: Token:::::::::: ' . $token);

		if ($token eq 'return' ) {
			YY_get_return();
		}

	}

	matchstring('}');
	$tab = $tab - 1;
	debug('YY_get_block: Returning with Tabs: ' . $tab . ' Token: ' . $token);
	$SPACES = $SPACES - 1;
}

# XXX This needs to be fleshed out...
sub YY_get_def {
	debug('YY_get_def: look: ' . $look);
	YY_get_type();
	YY_get_ident();
	matchstring('(');
	matchstring(')');
	YY_get_block();
}

sub YY_get_include {
	my ($incfile, $searchpath, $tmpfile, @dirs);

	$SPACES = $SPACES + 1;
	debug('YY_get_include: look: ' . $look);

	# XXX Should call getstring here not nexttoken...
	nexttoken();
	if ($token ne 'string') {
		error('YY_get_include: expected string got ' . $value);
	} else {
		$incfile = $value;
	}

	debug('YY_get_include: incflie: ' . $incfile);

	if ($ENV{'SW_LIB'}) {
		$searchpath = $ENV{'SW_LIB'};
	} else {
		$searchpath = '.:~/lib/sw:/usr/local/lib/sw';
	}

	debug('YY_get_include: searchpath = ' . $searchpath);

	@dirs = split(':', $searchpath);
	foreach my $i (@dirs) {
		$tmpfile = $i . '/' . $incfile;
		if (-f $tmpfile) {
			debug('getinclude: found ' . $tmpfile);
			pushfileinfo();

			find_output($tmpfile);

			read_compfile($tmpfile);

			popfileinfo();
			$SPACES = $SPACES - 1;
			return 1;
		} else {
			debug('getinclude: looking at ' . $tmpfile);
		}
	}

	error('Unable to find ' . $incfile . ' in searchpath: ' . $searchpath);
	$SPACES = $SPACES - 1;
	return 0;
}

sub YY_get_ident {
	$SPACES = $SPACES + 1;
	debug('YY_get_ident: Look: ' . $look);

	if (YY_is_alpha($look)) {
		$value = '';
		debug('YY_get_ident: Token: ' . $token . ' Value: ' . $value);

		while (YY_is_alphanum($look)) {
			$value = $value . $look;
			get_char();
		}

		if (intable($value)) {
			if (lookup_type($value) eq 'keyword') {
				$token = 'keyword';
			} else {
				$token = 'ident';
			}
		} else {
			$token = 'ident';
		}

		debug('YY_get_ident: Found Token: ' . $token . ' Value: ' . $value);
		emitln($value);
		$SPACES = $SPACES - 1;

		return $value;
	} else {
		error('Expected Name, got Token: ' . $token . ' Value: ' .  $value);
	}

	$SPACES = $SPACES - 1;

	return '';
}

sub YY_get_num {
	$SPACES = $SPACES + 1;
	debug('YY_get_num: Look: ' . $look);

	my $dec = 0;
	if (YY_is_digit($look) || $look eq '.') {
		$value = '';

		while(YY_is_digit($look) || $look eq '.') {

			if ($look eq '.') {
				$dec = $dec + 1;
				if ($dec > 1) {
					error('too many decimal points in ' . $value);
				}
			}
			$value = $value . $look;
			get_char();
		}

		if ($dec > 0) {
			$token = 'float';
		} else {
			$token = 'int';
		}

		debug('YY_get_num: Token: ' . $token . ' Value: ' . $value);
		emitln($value);
		$SPACES = $SPACES - 1;

		return $value; # XXX Do we need to convert to number here?
	} else {
		error('Expected Integer, got Token: ' . $token . ' Value: ' . $value);
	}

	$SPACES = $SPACES - 1;
	return 0;
}

sub YY_get_op {
	$SPACES = $SPACES + 1;
	debug('YY_get_op: Look: ' . $look);

	$token = $look;
	$value = $look;
	get_char();

	if ($token eq '/') {
		if ($look eq '*') {
			YY_get_multicomment();
		} elsif ($look eq '/') {
			warning('line: ' . $linenum . ': Using // style comments.');
			YY_get_comment();
		}
	} elsif ($token eq '-') {
		if ($look eq '-') {
			warning('line: ' . $linenum . ': Using -- style comments.');
			YY_get_comment();
		}
	} elsif (YY_is_relop($token) && ($look eq '=')) {
		$token = $token . $look;
		$value = $token;
		get_char();
		emitln($value);
	} elsif (YY_is_orop($token) && ($look eq $token)) {
		$token = $token . $look;
		$value = $token;
		get_char();
		emitln($value);
	}

	while (($look ne $EOF)) {
		nexttoken();
	}

	$SPACES = $SPACES - 1;
	return $value;
}

sub YY_get_multicomment {
	my $lastlook = '';

	$SPACES = $SPACES + 1;
	debug('YY_get_multicomment: Look: ' . $look);

	$value = '/*';
	get_char();

	while (($lastlook ne '*') && ($look ne '/')) {
		$value = $value . $look;
		$lastlook = $look;
		get_char();
	}
	# Need to finish the comment...
	get_char();
	$value = $value . '/';

	$token = 'multicomment';
	debug('YY_get_multicomment: Token: ' . $token . ' Value: ' . $value);
	emitln($value);
	$SPACES = $SPACES - 1;

	return $value;
}

# pass in " or ' so we know what we need to match...
sub YY_get_quotes {
	my ($strtype) = @_;
	my $lastlook = "";
	my $done = 0;

	$SPACES = $SPACES + 1;
	debug('YY_get_quotes: Look: ' . $look);

	get_char(); # Eat the quote

	$value = "";
	while (!$done) {
		if (($look eq $strtype) && ($lastlook ne "\\")) {
			$done = 1;
		} else {
			# XXX Should do something if $look eq "\"
			$value = $value . $look;
			$lastlook = $look;
			get_char();
		}
	}
	# eat the end quote
	get_char();

	$token = 'string';
	debug('YY_get_quotes: Token: ' . $token . ' Value: ' . $value);
	$SPACES = $SPACES - 1;

	return $value;
}

1;
