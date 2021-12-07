package tests;

use warnings;
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
	my ($text, $return_value, $function, @args) = @_;
	my ($value);

	if (!defined($function)) {
		print "Unable to find function: " . $function . "\n";
		return 0;
	}
	$value = &$function(@args);

	add_test();

	if ($value == $return_value) {
		add_success();
		print "ok " . total_tests() . " - " . $text . "\n";
		return 1;
	} else {

		print "notok " . total_tests() . " - " . $text . "\n";
		print "\tgot: " . $value . "\n";
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

	return 1;
}

1;
