package options;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(add_option set_option query_option query_help_option
	print_options parse_options);

my %options;

sub add_option {
	my ($flag, $help, $setable) = @_;

	$options{$flag}->{'help'} = $help;
	$options{$flag}->{'value'} = 0;
	if ($setable) {
		$options{$flag}->{'setable'} = $setable;
	}

	return 1;
}

sub set_option {
	my ($flag, $value) = @_;

	if (exists($options{$flag})) {
		$options{$flag}->{'value'} = $value;
		return 1;
	}

	print "Option: $flag does not exist.\n";
	return 0;
}

sub query_option {
	my ($flag) = @_;

	if (exists($options{$flag})) {
		return $options{$flag}->{'value'};
	}

	print "Option: $flag does not exist.\n";
	return 0;
}

sub query_help_option {
	my ($flag) = @_;

	if (exists($options{$flag})) {
		return $options{$flag}->{'help'};
	}
	print "Option: $flag does not exist.\n";
	return 0;
}

sub print_options {
	my $c = 0;
	my $st;

	print "Options:\n";

	foreach my $i (keys(%options)) {
		if (exists($options{$i}->{'setable'})) {
			$st = sprintf("\t%-20s %s\n", "--$i=" .
				$options{$i}->{'setable'},
				$options{$i}->{'help'});
			print $st;
		} else {
			$st = sprintf("\t%-20s %s\n", "--$i",
				$options{$i}->{'help'});
			print $st;
		}
		$c = $c + 1;
	}
	return $c;
}

sub parse_options {
	my (@args) = @_;
	my @args2;

	foreach my $i (@args) {
		my $done = 0;
		if ($i =~ /-.*/) {
			foreach my $x (keys(%options)) {
				if ($i =~ /--$x="([^"]*)"(.*)/) {
					my $rest = $1;

					set_option($x, $rest);
					$done = 1;
				} elsif ($i =~ /--$x=([^\ ]*)(.*)/) {
					my $rest = $1;

					set_option($x, $rest);
					$done = 1;
				} elsif ($i =~ /--$x/) {
					set_option($x, 1);
					$done = 1;
				}
			}
			if (!$done) {
				print "Invalid option $i\n";
				return 0;
			}
		} else {
			push(@args2, $i);
		}
	}

	return @args2;
}

1;
