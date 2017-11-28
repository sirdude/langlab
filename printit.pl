#!/usr/bin/perl

use strict;
use warnings;
my %rules;

sub is_rule {
	my ($tmp) = @_;

	if (exists($rules{$tmp})) {
		return 1;
	}

	return 0;
}

sub is_terminal {
	my ($tmp) = @_;

	if ($tmp =~ /^\'[^\']*'$/) {
		return 1;
	}

	return 0;
}

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
		if (is_terminal($x) || is_rule($x)) {
			print "\tif (\$ptr eq $x) {\n";
			print "\t\treturn 1;\n";
			print "\t}\n";
		} 

		print "Unable to parse complex rule: {" . $value . "} = $x\n";
	}

	print "\n\treturn 0;\n";

	print "\n}\n\n";

	return 1;
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

	return 1;
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

insert_rule("Uppercase", "A");
insert_rule("Uppercase", "B");
insert_rule("Uppercase", "C");
insert_rule("Uppercase", "D");
insert_rule("Uppercase", "E");
insert_rule("Uppercase", "F");
insert_rule("Uppercase", "G");

insert_rule("Lowercase", "a");
insert_rule("Lowercase", "b");
insert_rule("Lowercase", "c");
insert_rule("Lowercase", "d");
insert_rule("Lowercase", "e");
insert_rule("Lowercase", "f");
insert_rule("Lowercase", "g");

insert_rule("Letter", "Lowercase");
insert_rule("Letter", "Uppercase");

generate_code();
