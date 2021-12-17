package tok_ident;

use strict;
use warnings;

# Not all of these will be in our language but they are used in different
# # languages this is more generic
my %keywords = ('int' => 'type', 'float' => 'type', 'string' => 'type',
	'void' => 'type', 'mixed' => 'type', 'mapping' => 'type', 'object' => 'type',
	'boolean' => 'type', 'short' => 'type', 'long' => 'type', 'double' => 'type',
	'nil' => 'type', 'null' => 'type', 'const' => 'type', 'array' => 'type',
	'var' => 'type', 'hash' => 'type',
	'static' => 'typemod', 'atomic' => 'typemod', 'private' => 'typemod',
	'unsigned' => 'typemod', 'nomask' => 'typemod',
	'include' =>'package', 'inherit' => 'package', 'lib' => 'package', 
	'for' => 'statement', 'while' => 'statement', 'if' => 'statement',
	'else' => 'statement', 'switch' => 'statement', 'return' => 'statement',
	'exit' => 'statement', 'break' => 'statement', 'case' => 'statement',
	'default' => 'statement', 'continue' => 'statement', 'do' => 'statement',
	'try' => 'statement', 'new' => 'statement', 'public' => 'statement',
	'elseif' => 'statement', 'read' => 'statement', 'write' => 'statement',
	'goto' => 'statement', 'sizeof' => 'statement', 'foreach' => 'statement',
	'keys' => 'statement',
	'eval' => 'statement', 'catch' => 'statement', 'struct' => 'statement',
	'class' => 'statement', 'declare' => 'statement', 'sub' => 'statement',
	'define' => 'statement', 'throw' => 'statement');

sub is_keyword {
	my ($input) = @_;

	foreach my $i (keys %keywords) {
		if ($input eq $i) {
			return 1;
		}
	}
	return 0;
}

sub start {
	my ($ast) = @_;
	# A-Z, a-z, _
	my @values = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
		'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
		'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
		'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u',
		'v', 'w', 'x', 'y', 'z', '_');

	$ast->debug('tok_ident::start');
	foreach my $i (@values) {
		if ($ast->match($i)) {
			return 1;
		}
	}

	return 0;
}

sub start_num {
	my ($ast) = @_;
	my @values = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');

	$ast->debug('tok_ident::start_num');
	foreach my $i (@values) {
		if ($ast->match($i)) {
			return 1;
		}
	}
	return 0;
}

sub get {
	my ($ast, $outast, $flag) = @_;
	my ($p, $l) = $ast->get_loc();
	my ($word, $tmp);

	$ast->push_scope();
	$ast->debug('tok_ident::get');

	if (!start($ast)) {
		$ast->pop_scope();
		return 0;
	}

	$tmp = $ast->consume();
	$word = $tmp;

	$ast->debug("ident::get: start = '$word'");
	while (start_num($ast) || start($ast)) {
		$tmp = $ast->consume();
		$word .= $tmp;
	}

	$ast->debug("ident::get: '$word'");
	if (is_keyword($word)) {
		$outast->add_base_node($keywords{$word}, $word, $l, $p);
	} else {
		$outast->add_base_node('ident', $word, $l, $p);
	}
	$ast->pop_scope();
	return 1;
}

1;
