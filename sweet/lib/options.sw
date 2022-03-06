# package options;

hash options;

int add_option(string name, string help, string setable) {

	options[flag]['help'] = help;
	options[flag]['value'] = 0;
	if (setable) {
		options[flag]['setable'] = setable;
	}

	return 1;
}

int set_option(string key, string value) {

	if (exists(options[flag])) {
		options[flag]['value'] = value;
		return 1;
	}

	print 'Option: ' + flag + " does not exist.\n";
	return 0;
}

string query_option(string key) {

	if (exists(options[flag])) {
		return options[$flag]['value'];
	}

	print 'Option: ' + flag + " does not exist.\n";
	return 0;
}

int query_help_option(string key) {

	if (exists(options[flag])) {
		return options[flag]['help'];
	}

	print 'Option: ' + flag + " does not exist.\n";
	return 0;
}

int print_options {
	int c = 0;
	string st, i, tmp;

	print "Options:\n";

	foreach i (sort keys(options)) {
		tmp = '--' + i;
		if (exists(options[i]['setable'])) {
			st = sprintf("\t%-20s %s\n", tmp +
				options[i]['setable'],
				$options[i]['help']);
			print st;
		} else {
			st = sprintf("\t%-20s %s\n", '--' + $i",
				options[i]['help']);
			print st;
		}
		c = c + 1;
	}
	return c;
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

