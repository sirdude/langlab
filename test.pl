#!/usr/bin/perl

use strict;
use warnings;
my %rules;

sub insert_rule {
	my ($lhs, $rhs) = @_;

	if (exists($rules{$lhs})) {
		my @tmp = @{$rules{$lhs}};
		foreach my $i (@tmp) {
			if ($rhs eq $i) {
				print "Error Duplcate rule: $lhs ::= $rhs\n";
				return 0;
			}
		}
	}

	push(@{$rules{$lhs}}, $rhs);

	return 1;
}

sub generate_is {
	my ($value) = @_;

	print "sub is_" . $value . "{\n";
	print "\tmy (\$ptr) = \@_;\n\n";

	my @tmp = @{$rules{$value}};
	foreach my $x (@tmp) {
		print "\tif (\$ptr eq $x) {\n";
		print "\t\treturn 1;\n";
		print "\t}\n";
	}

	print "\n\treturn 0;\n";

	print "\n}\n\n";
}

sub generate_do {
	my ($value) = @_;

	print "sub do_" . $value . "{\n";
	print "\tmy (\$ptr) = \@_;\n\n";

	print "\tif (!is_" . $value . "(\$ptr) {\n";
	print "\t\tprint \"Error!!! Expected something else here: XXX\\n\";\n";
	print "\t\treturn 0;\n";
	print "\t}\n";

	print "XXX Do consume here\n";

	print "\n\treturn 0;\n";

	print "\n}\n\n";
}

sub generate_code {
	foreach my $i (keys %rules) {
		generate_is($i);
		generate_do($i);
	}
}

insert_rule("Digit", "0");
insert_rule("Digit", "1");
insert_rule("Digit", "2");
insert_rule("Digit", "3");
insert_rule("Digit", "4");
insert_rule("Digit", "5");
insert_rule("Digit", "6");
insert_rule("Digit", "7");
insert_rule("Digit", "8");
insert_rule("Digit", "9");

generate_code();
