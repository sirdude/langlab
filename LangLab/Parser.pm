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

	if ($tree[$current]->{'value'} ne "#") {
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

sub get_id {
	my $node;

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

sub parser_main {
	(@tree) = @_;
	$current = 0;
	$treesize = @tree;

	# XXX Do the work here...

	return 1;
}

1;
