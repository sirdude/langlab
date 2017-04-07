package Parser;

use strict;
use warnings;

# XXX Need to redo this so its not hard codeded into each file...
my $EOF = "EOF__XXX";
my $EOL = "EOL__XXX";

our @EXPORT = qw(
	parser_main
        );

my ($current, $treesize, @tree);

sub get_single_comment {
	my ($node, $done);

	if (($tree[$current]->{'value'} ne "#") &&
		($tree[$current]->{'value'} ne "--")) {
		print "Called get_single_comment, and first value is not " .
			" the start of a single line comment.\n";
		return 0;
	}

	$node->{'value'} = "";
	$node->{'type'} = "singlecomment";
	$node->{'file'} = $tree[$current]->{'value'};
	$node->{'pos'} = $tree[$current]->{'pos'};

	while (!$done && ($tree[$current]->{'value'} ne $EOL)) {
		$node->{'value'} = $node->{'value'} .
			$tree[$current]->{'value'};

		$current = $current + 1;
		if ($current < $treesize) {
			$done = 1;
		}
	}

	if (!$done) { 
		$node->{'value'} = $node->{'value'} .
			$tree[$current]->{'value'};
		$current = $current + 1;
	}

	return $node;
}

sub get_multi_comment {
	my ($node, $done);

	if ($tree[$current]->{'value'} ne "/*") {
		print "Called get_multi_comment, and first value is not " .
			" the start of a multi line comment.\n";
		return 0;
	}

	$node->{'value'} = "";
	$node->{'type'} = "singlecomment";
	$node->{'file'} = $tree[$current]->{'value'};
	$node->{'pos'} = $tree[$current]->{'pos'};

	while (!$done && ($tree[$current]->{'value'} ne "*/")) {
		$node->{'value'} = $node->{'value'} .
			$tree[$current]->{'value'};

		$current = $current + 1;
		if ($current < $treesize) {
			$done = 1;
		}
	}

	if (!$done) { 
		$node->{'value'} = $node->{'value'} .
			$tree[$current]->{'value'};
		$current = $current + 1;
	} else {
		print "Error: " .  $node->['file'] .
			" line " . $node->['pos'] .
			"non terminated multi line comment.\n";
		return 0;
	}

	return $node;
}

sub is_letter {
	my ($char) = @_;

	if (($char >= 'a') && ($char <= 'z')) {
		return 1;
	}
	if (($char >= 'A') && ($char <= 'Z')) {
		return 1;
	}

	return 0;
}

sub is_digit {
	my ($char) = @_;

	if ($char eq "1") {
	} elsif ($char eq "2") {
	} elsif ($char eq "3") {
	} elsif ($char eq "4") {
	} elsif ($char eq "5") {
	} elsif ($char eq "6") {
	} elsif ($char eq "7") {
	} elsif ($char eq "8") {
	} elsif ($char eq "9") {
	} elsif ($char eq "0") {
	} else {
		return 0;
	}

	return 1;
}

sub get_id {
	my ($node, $done);

	$done = 0;

	if (!is_letter($tree[$current]->{'value'})) {
		print "Error: " .  $node->['file'] .
			" line " . $node->['pos'] .
			"Expected ID which starts with a Letter.\n";
		return 0;
	}

	$node->{'value'} = "";
	$node->{'type'} = "ident";
	$node->{'file'} = $tree[$current]->{'value'};
	$node->{'pos'} = $tree[$current]->{'pos'};

	while(!$done && (is_letter($tree[$current]->{'value'}) ||
		is_digit($tree[$current]->{'value'}))) {
		$node->{'value'} = $node->{'value'} . 
			$tree[$current]->{'value'};
		$current = $current + 1;

		if ($current > $treesize) {
			$done = 1;
		}
	}

	return $node;
}

sub get_doublequotestring {
	my ($node, $done);

	if ($tree[$current]->{'value'} ne "\"") {
		print "Called get_dobulequotestring, and first value is not " .
			" the start of a string.\n";
		return 0;
	}

	$node->{'value'} = "";
	$node->{'type'} = "doublequotestring";
	$node->{'file'} = $tree[$current]->{'value'};
	$node->{'pos'} = $tree[$current]->{'pos'};
	
	while (!$done && ($tree[$current]->{'value'} ne "\"")) {

		if ($tree[$current]->{'value'} eq $EOL) {
			print "Warning: " . $node->['file'] . 
				" line " . $node->['pos'] .
				"string not terminated before end of line.\n";
		}

		$node->{'value'} = $node->{'value'} .
			$tree[$current]->{'value'};

		$current = $current + 1;
		if ($current > $treesize) {
			$done = 1;
		}
	}

	if ($done) { 
		print "Error: " .  $node->['file'] .
			" line " . $node->['pos'] .
			"non terminated string.\n";
		return 0;
	}

	return $node;
}

sub get_singlequotestring {
	my ($node, $done);

	if ($tree[$current]->{'value'} ne "\'") {
		print "Called get_singlequotestring, and first value is not " .
			" the start of a string.\n";
		return 0;
	}

	$node->{'value'} = "";
	$node->{'type'} = "doublequotestring";
	$node->{'file'} = $tree[$current]->{'value'};
	$node->{'pos'} = $tree[$current]->{'pos'};
	
	while (!$done && ($tree[$current]->{'value'} ne "\'")) {

		if ($tree[$current]->{'value'} eq $EOL) {
			print "Warning: " . $node->['file'] . 
				" line " . $node->['pos'] .
				"string not terminated before end of line.\n";
		}

		$node->{'value'} = $node->{'value'} .
			$tree[$current]->{'value'};

		$current = $current + 1;
		if ($current < $treesize) {
			$done = 1;
		}
	}

	if ($done) { 
		print "Error: " .  $node->['file'] .
			" line " . $node->['pos'] .
			"non terminated string.\n";
		return 0;
	}

	return $node;
}

sub is_whitespace {
	my ($char) = @_;

	if ($char eq " ") {
	} elsif ($char eq "\t") {
	} else {
		return 0;
	}

	return 1;
}

sub eat_whitespace {
	my ($node, $done);

	$node->{'value'} = "";
	$node->{'type'} = "doublequotestring";
	$node->{'file'} = $tree[$current]->{'value'};
	$node->{'pos'} = $tree[$current]->{'pos'};

	while (!$done && is_whitespace($tree[$current]->{'value'})) {
		$node->{'value'} = $node->{'value'} .
			$tree[$current]->{'value'};
		$current = $current + 1;
		if ($current > $treesize) {
			$done = 1;
		}
	}

	if ($node->{'value'} ne "") {
		return $node;
	}

	return 0;
}

sub parser_main {
	(@tree) = @_;
	$current = 0;
	$treesize = @tree;

	# XXX Do the work here...

	return 1;
}

1;
