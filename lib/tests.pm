package tests;

use warnings;
use Term::ANSIColor;
use base 'Exporter';
use Scalar::Util qw(reftype);

our @EXPORT = qw(add_test add_success total_tests total_success is is_quiet
	init_tests test_summary compare_array compare_hash);

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

sub is_hash {
	my ($input) = @_;

	if (ref($input) && (reftype($input) eq "HASH")) {
		return 1;
	}
	return 0;
}

sub is_array {
	my ($input) = @_;

	if (ref($input) && (reftype($input) eq "ARRAY")) {
		return 1;
	}
	return 0;
}

sub compare_hash {
	my ($h1, $h2) = @_;
	my %rhash_1 = %$h1;
	my %rhash_2 = %$h2;

	my $hash_2_line = undef;
	my $hash_1_line = undef;

	foreach my $key ( keys(%rhash_2) ) {
		if ( exists( $rhash_1{$key} ) ) {
			if ( $rhash_1{$key} ne $rhash_2{$key} ) {
				return 0;
			}
	 	} else {
			return 0;
   		}
	}

	foreach my $comp_key ( keys %rhash_1 ) {
		if ( !exists( $rhash_2{$comp_key} ) ) {
			return 0;
		}
	}

	return 1;
}

sub compare_array {
	my ($h1, $h2) = @_;

	if (!$h1 && !$h2) {
		return 1;
	}

	if ((!$h1 && $h2) || ($h1 && !$h2)) {
		return 0;
	}

	my $len = length($h1);

	if ($len ne length($h2)) {
		return 0;
	}

	my $x = 0;
	while ($x < $len) {
		if (!exists($h1[$x]) || !exists($h2[$x])) {
			return 0;
		}
		if ($h1[$x] ne $h2[$x]) {
			return 0;
		}
		$x = $x + 1;
	}

	return 1;
}

sub is {
	my ($first, $second, $text) = @_;
	if (is_quiet($first, $second)) {
		print color('bold green') . "ok " . color('reset') . total_tests() . " - $text\n";

		return 1;
	}
	print color('bold red') . "not ok " . color('reset') . total_tests() . " - $text\n";

	return 0;
}


sub is_quiet {
	my ($functioncall, $expected, $text) = @_;

	add_test();

	if (is_hash($functioncall) || is_hash($expected)) {
		return compare_hash($functioncall, $expected);
	} elsif (is_array($functioncall) || is_array($expected)) {
		return compare_array($functioncall, $expected);
	} elsif (!$functioncall) {
		if (!$expected) {
			add_success();
			return 1;
		} else {
			return 0;
		}
	} elsif ($functioncall eq $expected) {
		add_success();
		return 1;
	} else {
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
