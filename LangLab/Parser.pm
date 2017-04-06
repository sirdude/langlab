package Parser;

use strict;
use warnings;

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
	my $node;

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
