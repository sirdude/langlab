package tests;

use warnings;
use Term::ANSIColor;
use base 'Exporter';

our @EXPORT = qw(add_test add_success total_tests total_success is
	init_tests test_summary);

my ($tests, $success);

sub add_test {
	$tests = $tests + 1;

	return $tests;
}

sub add_success {
	$success = $success + 1;

	return $success;
}

sub total_tests {
	return $tests;
}

sub total_success {
	return $success;
}

sub is {
	my ($functioncall, $expected, $text) = @_;

	add_test();

	if (!$functioncall && !$expected) {
		add_success();
		print color('bold green') . "ok " . color('reset') . total_tests() . " - $text\n";
		return 1;
	} elsif ($functioncall eq $expected) {
		add_success();
		print color('bold green') . "ok " . color('reset') . total_tests() . " - $text\n";
		return 1;
	} else {
		print color('bold red') . "notok " . color('reset') . total_tests() . " - $text\n";
		print "\tgot: " . $functioncall .  " expected: $expected\n";
		return 0;
	}
}

sub init_tests {
	$tests = 0;
	$success = 0;

	return 1;
}

sub test_summary {
	print "Total tests: " . total_tests() . " :Success: " .
		total_success() . "\n";

	if (total_tests() eq total_success()) {
		return 0;
	}

	return total_tests() - total_success();
}

1;
