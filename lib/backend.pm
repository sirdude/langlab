package backend;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(get_char insert_symbol debug open_output close_output
	init_backend read_compfile open_compfile close_compfile set_debug
	set_eof get_eof test_rule load_backend write_stats print_tokens
	last_token @keywords %stats);

our $SPACES = 0;       # Indentation for debugging.
our $EOF;              # String to use to denote end of file.

my $ofile;             # file handle for current output
my $infile;            # file handle for current input
our $parsestring;      # String to parse instead of a file.

my %symtable;          # hash that is used for our symbol table.
my %symcount;          # hash used to keep track of how many times our
                       # symbols are referenced.
my @filesinfo;         # stack to handle multiple files.
our %stats;             # Hash of stats we want to collect.
my $statsfile = "stats.txt";   # location where we store stats about our parsing

our $buf;              # used internally for match lookahead
my $bufsize = 9;       # number of chars we buffer for match
my $doneread = 0;      # Done reading (this is needed because we are using 
                       # a buffer)

my @tokens;            # Used to store our token stream
my $last_tok_type;
my $last_tok_value;

# These functions are used to report errors and or warnings
sub error {
	my ($msg) = @_;

	if (!$stats{'filename'} || $stats{'filename'} eq "") {
		print 'Error ' . $msg . "\n";
	} else {
		print 'Error ' . $stats{'filename'} . ':l:' .
			$stats{'linenum'} . ':c:' .
			$stats{'columnnum'} . '\:\: ' . $msg . "\n";
	}
	return 1;
}

sub warning {
	my ($msg) = @_;

	if (!$stats{'filename'} || $stats{'filename'} eq "") {
		print 'WARNING ' . $msg . "\n";
	} else {
		print 'WARNING ' . $stats{'filename'} . ':l:' .
			$stats{'linenum'} .
			':c:' .  $stats{'columnnum'} . '\:\: ' . $msg . "\n";
	}
	return 1;
}

sub debug {
	my ($msg) = @_;

	if (query_option('debug')) {
		my $s = '';
		my $x = 0;
		while ($x < $SPACES) {
			$x = $x + 1;
			$s = $s . '  ';
		}
		print 'DEBUG: ' . $s . $msg . "\n";
		return 1;
	}
	return 0;
}

sub set_debug {
	my ($debug) = @_;

	set_option('debug', $debug);
	return $debug;
}

sub set_eof {
	($EOF) = @_;

	$SPACES = $SPACES + 1;
	debug('set_eof: EOF = ' . $EOF);
	$SPACES = $SPACES - 1;

	return $EOF;
}

sub get_eof {
	return $EOF;
}

# These two functions are used to generate code.
sub emit {
	my ($str) = @_;
	my $tabc;

	$tabc = 0;
	while ($tabc < $stats{'tab'}) {
		print $ofile "\t";
		$tabc = $tabc + 1;
	}
	print $ofile $str;

	return 1;
}

sub emitln {
	my ($msg) = @_;

	return emit($msg . "\n");
}

# Misc functions
sub in_set {
	my ($in, @setlist) = @_;

	foreach my $i (@setlist) {
		if ($i eq $in) {
			return 1;
		}
	}
	return 0;
}

sub pushfileinfo {
	my %fileinfo;

	$SPACES = $SPACES + 1;
	debug('pushfileinfo:');

	$fileinfo{'infile'} = $infile;
	$fileinfo{'linenum'} = $stats{'linenum'};
	$fileinfo{'columnnum'} = $stats{'columnnum'};
	$fileinfo{'tab'} = $stats{'tab'};
	$fileinfo{'maxtab'} = $stats{'maxtab'};
	$fileinfo{'casetype'} = $stats{'casetype'};

	push(@filesinfo, \%fileinfo);

	if (query_option('debug')) {
		print "Pushing fileinfo:\n";
		foreach my $i (keys %fileinfo) {
			debug("\t" . $i . ' = ' . $fileinfo{$i});
		}
	}
	$SPACES = $SPACES - 1;
	return 1;
}

sub popfileinfo {
	my ($fileinfo) = pop(@filesinfo);

	$SPACES = $SPACES + 1;
	debug('popfileinfo:');

	$infile = $fileinfo->{'infile'};
	$stats{'linenum'} = $fileinfo->{'linenum'};
	$stats{'columnnum'} = $fileinfo->{'columnnum'};
	$stats{'tab'} = $fileinfo->{'tab'};
	$stats{'maxtab'} = $fileinfo->{'maxtab'};
	$stats{'casetype'} = $fileinfo->{'casetype'};

	if (query_option('debug')) {
		print "Popping fileinfo:\n";
		print "\tinfile = " . $infile . "\n";
		print "\tlinenum = " . $stats{'linenum'} . "\n";
		print "\tcolumnnum = " . $stats{'columnnum'} . "\n";
		print "\ttab = " . $stats{'tab'} . "\n";
		print "\tmaxtab = " . $stats{'maxtab'} . "\n";
		print "\tcasetype = " . $stats{'casetype'} . "\n";
	}
	$SPACES = $SPACES - 1;
	return 1;
}

# Simple symbol table functions
sub lookup_value {
	my ($var) = @_;

	if (exists($symtable{$var})) {
		return $symtable{$var}->{'value'};
	}

	return "";
}

sub lookup_type {
	my ($var) = @_;

	if (exists($symtable{$var})) {
		return $symtable{$var}->{'type'};
	}
	return '';
}

sub intable {
	my ($var) = @_;

	if (exists($symtable{$var})) {
		if (exists($symcount{$var})) {
			$symcount{$var} = $symcount{$var} + 1;
		} else {
			$symcount{$var} = 1;
		}

		return 1;
	}

	return 0;
}

sub insert_symbol {
	my ($sym, $type, $val) = @_;
	my %tmp;

	$SPACES = $SPACES + 1;
	debug('insert_symbol: Sym: ' . $sym . ' Type: ' .
		$type . ' Val: ' . $val);

	if (intable($sym)) {
		error('Duplicate entry: ' . $sym);
		$SPACES = $SPACES - 1;
		return 0;
	}

	$tmp{'value'} = $val;
	$tmp{'type'} = $type;
	$symcount{$sym} = 1;
	$symtable{$sym} = \%tmp;

	$SPACES = $SPACES - 1;
	return 1;
}

sub dump_table {
	my ($tmp, $val);

	print "Symbol Table Dump:\n";
	foreach my $i (keys %symtable) {
		$tmp = $symtable{$i};

		if (exists($tmp->{"value"})) {
			$val = $tmp->{"value"};
		} else {
			$val = "null";
		}

		if ($tmp->{"type"} eq "keyword") {
			print "\tSymbol: " . $i . ": type: " . $tmp->{"type"} .
				" count: " . $symcount{$i} . "\n";
		} else {
			print "\tSymbol: " . $i . ": type: " . $tmp->{"type"} .
				" value: " . $val . " count: " . $symcount{$i} .
				"\n";
		}
	}
	print "\n\n";

	return 1;
}

sub add_stat {
	my ($stype, $skey, $svalue) = @_;

	debug("add_stat: $stype: $skey: $svalue");
	my $tmp = $stype . ":" . $skey;
	if (exists($stats{$tmp})) {
		$stats{$tmp} = $stats{$tmp} + $svalue;
	} else {
		$stats{$tmp} = $svalue;
	}
	return 1;
}

sub write_stats {
	my ($statfile) = @_;
	my ($sfh);

	debug("write_stats");
	open($sfh,">>", $statfile) or die
		"Unable to open stats file: $statfile\n";
	if ($sfh) {
		foreach my $i (keys %stats) {
			if ($i eq "whitespace:\n") {
				print $sfh "whitespace:\\n:" . $stats{$i} . "\n";
			} elsif ($i eq "whitespace:\r") {
				print $sfh "whitespace:\\r:" . $stats{$i} . "\n";
			} elsif ($i eq "whitespace:\t") {
				print $sfh "whitespace:\\t:" . $stats{$i} . "\n";
			} else {
				print $sfh "$i:" . $stats{$i} . "\n";
			}
		}
		close ($sfh);
		return 1;
	}
	return 0;
}

sub buf_push {
	my ($in) = @_;

	$buf = $buf . $in;
	return 1;
}

sub buf_pop {
	my $tmp;

	if (match($EOF)) {
		$tmp = $EOF;
		$buf = substr($buf,length($EOF));
	} else {
		$tmp = substr($buf,0,1);
		$buf = substr($buf,1);
	}

	return $tmp;
}

sub buf_clear {
	$buf = "";
	return 1;
}

sub buf_show {
	print "Buf:$bufsize:\'$buf\'\n";
	return 1;
}

sub _get_char {
	my $char; 

	$SPACES = $SPACES + 1;
	if (!$stats{'filename'} || ($stats{'filename'} eq '<STDIN>') ||
		($stats{'filename'} eq '')) {
		if ($parsestring) {
			if ($stats{'totalchars'} >= length($parsestring)) {
				$char = $EOF;
			} else {
				$char = substr($parsestring,
					$stats{'totalchars'}, 1);
			}
		} else {
			$char = getc();
		}
	} else {
		if (!$doneread) {
			if (!sysread($infile, $char, 1)) {
				$doneread = 1;
				$char = $EOF;
			} else {
				$stats{'totalchars'} = $stats{'totalchars'} + 1;
				$stats{'all_totalchars'} =
					$stats{'all_totalchars'} + 1;
			}
		} else {
			$char = $EOF;
		}
	}

	if ($char eq "\n") {
		$stats{'linenum'} += 1;
		$stats{'alllinenum'} += 1;
		$stats{'columnnum'} = 0;
	} else {
		$stats{'columnnum'} += 1;
	}

	debug('_get_char: returning ' . $char);
	$SPACES = $SPACES - 1;
	return $char;
}

sub match {
	my ($x) = @_;
	my $size = length($x);

	$SPACES = $SPACES + 1;

	debug('match:');
	if (query_option("debug")) {
		buf_show();
	}

	while ($size > $bufsize) {
		error("'$x' greater than our buffer size: $bufsize");
		error("Increasing bufsize by one.");

		$bufsize = $bufsize + 1;
		my $tmp = _get_char();
		buf_push($tmp);
	}

	$SPACES = $SPACES - 1;
	if (substr($buf, 0, $size) eq $x) {
		return 1;
	}

	return 0;
}

sub get_comma {
	if (match(',')) {
		$SPACES = $SPACES + 1;
		debug('comma: consumed comma');
		nextchar();
		$SPACES = $SPACES - 1;
		return 1;
	}
	return 0;
}

sub get_semi {
	if (match(';')) {
		$SPACES = $SPACES + 1;
		debug('semi: consumed ;');
		nextchar();
		$SPACES = $SPACES - 1;
		return 1;
	}

	return 0;
}

sub open_output {
	my ($tfile) = @_;

	$SPACES = $SPACES + 1;

	debug('open_output: outfile = ' . $tfile);

	open($ofile, '>', $tfile) or die "Unable to write to $tfile.\n";
	$SPACES = $SPACES - 1;
	return 1;
}

sub close_output {
	$SPACES = $SPACES + 1;
	debug('close_output:');

	$SPACES = $SPACES - 1;
	if ($ofile) {
		return close($ofile);
	}

	return 1;
}

sub open_compfile {
	my ($filename) = @_;

	$SPACES = $SPACES + 1;
	debug('open_compfile:' . $filename);

	$stats{'linenum'} = 0;
	$stats{'columnnum'} = 0;
	$stats{'tab'} = 0;
	$stats{'maxtab'} = 0;
	$stats{'filename'} = $filename;

	if ($filename && ($filename ne '')) {
		open($infile,'<', $filename) or
			die "Unable to open $filename\n";
	}
	$SPACES = $SPACES - 1;
	return 1;
}

sub close_compfile {
	$SPACES = $SPACES + 1;
	debug('close_compfile:');

	if ($infile) {
		$SPACES = $SPACES - 1;
		return close($infile);
	}

	$SPACES = $SPACES - 1;
	return 1;
}

sub read_compfile {
	my ($tfile) = @_;
	my $x = 0;

	$SPACES = $SPACES + 1;
	debug('read_compfile: reading file: ' . $tfile);

	open_compfile($tfile);

	while ($x < $bufsize) {
		my $tmp = _get_char();
		$x = $x + 1;
		buf_push($tmp);
	}

	# This is our hook to our language specific code
	parser();

	close_compfile();
	$SPACES = $SPACES - 1;

	return 1;
}

sub init_backend {
	my @keyw = @_;

	$SPACES = $SPACES + 1;
	debug('init_backend: setting defaults');

	%symtable = ();
	%symcount = ();
	%stats = ();

	@tokens = ();
	$buf = "";
	# $bufsize = 9; 	# declared at the top 

	if (@keyw) {
		validate_keywords();
		foreach my $i (@keyw) {
			insert_symbol($i, 'keyword', $i);
		}
	}

	$stats{'totalchars'} = 0;
	$stats{'all_totalchars'} = 0;
	$stats{'all_linenum'} = 0;
	# These get reset in open_file but are needed for input from stdin...
	$stats{'linenum'} = 0;
	$stats{'columnnum'} = 0;
	$stats{'tab'} = 0;
	$stats{'maxtab'} = 0;
	$stats{'filename'} = '<STDIN>';
	$stats{'project_name'} = "My Project";
	$stats{'project_description'} = "A simple project, details to follow later.";
	$stats{'filepath'} = ".";
	$stats{'filetype'} = "unknown";
	
	$last_tok_type = "";
	$last_tok_value = "";

	$SPACES = $SPACES - 1;

	return 1;
}

sub get_char {
	my $tmp = _get_char();

	buf_push($tmp);
	$tmp = buf_pop();

	if ($tmp eq "\n") {
		$stats{'linenum'} = $stats{'linenum'} + 1;
		$stats{'all_linenum'} = $stats{'all_linenum'} + 1;
		$stats{'columnnum'} = 0;
	} elsif ($tmp eq $EOF) {
	} else {
		$stats{'columnnum'} = $stats{'columnnum'} + 1;
	}
	$stats{'totalchars'} = $stats{'totalchars'} + 1;
	$stats{'all_totalchars'} = $stats{'all_totalchars'} + 1;

	return $tmp;
}

sub load_backend {
	my ($file) = @_;

	if (-f $file) {
		do $file;
		return 1;
	} else {
		print "Unable to locate $file\n";
		return 0;
	}
}

sub add_token {
	my ($type, $tvalue, $pos, $line) = @_;
	my $tmp;

	if (($last_tok_type eq $type) && 
		!common_follows($last_tok_value, $tvalue)) {
		print "WARNING double token type: $last_tok_value$tvalue, " .
			"p: $pos, l: $line\n";
	}
	$last_tok_type = $type;
	$last_tok_value = $tvalue;

	debug("add_token: $type: $tvalue l:$line p:$pos");
	$tmp->{'type'} = $type;
	$tmp->{'value'} = $tvalue;
	$tmp->{'line'} = $line;
	$tmp->{'pos'} = $pos;

	push(@tokens, $tmp);
	return 1;
}

sub print_whitespace {
	my ($space) = @_;

	$space =~ s/\n/\\n/g;
	$space =~ s/\t/\\t/g;
	$space =~ s/\r/\\r/g;

	return $space;
}

# XXX Need to handled multiple files, and output file as well right now
# it just prints to screen.
sub print_tokens {
	my ($outputtype) = @_;
	my $count = 0;

	debug("print_tokens");
	if ($outputtype eq "xml") {
		print "<PROJECT>\n";
		print "\t<PROJECTNAME>" . $stats{'project_name'} .
			"</PROJECTNAME>\n";
		print "\t<PROJECTDESCRIPTION>" . $stats{'project_description'} .
			"</PROJECTDESCRIPTION>\n";
		print "\t<FILES>\n";

		print "\t\t<FILE>\n";
		print "\t\t\t<FILENAME>" . $stats{'filename'} . "</FILENAME>\n";
		print "\t\t\t<PATH>" . $stats{'filepath'} . "</PATH>\n";
		print "\t\t\t<TYPE>" . $stats{'filetype'} . "</TYPE>\n";

		foreach my $t (@tokens) {
			$count = $count + 1;
			print "\t\t\t\t<TOKEN>\n";
			print "\t\t\t\t<ID>" . $count . "</ID>\n";
			print "\t\t\t\t<LINENUM>" . $t->{'line'} .
				"</LINENUM>\n";
			print "\t\t\t\t<COLUMNNUM>" . $t->{'pos'} .
				"</COLUMNNUM>\n";
			print "\t\t\t\t<TYPE>" . $t->{'type'} . "</TYPE>\n";
			if ($t->{'type'} eq "whitespace") {
				print "\t\t\t\t<VALUE>" .
					print_whitespace($t->{'value'}) .
					"</VALUE>\n";
			} else {
				print "\t\t\t\t<VALUE>" . $t->{'value'} .
					"</VALUE>\n";
			}
			print "\t\t\t\t</TOKEN>\n\n";
		}

		print "\t\t\t</TOKENS>\n";
		print "\t\t</FILE>\n";
		print "\t</FILES>\n";
		print "</PROJECT>\n";

	} elsif ($outputtype eq "json") {
		print "{\n";
		print "\t\"ProjectName\" : \"" . $stats{'project_name'} . "\"\n";
		print "\t\"ProjectDescription\" : \"" .
			$stats{'project_description'} . "\"\n";
		print "\t\"Files\" : [\n";
		print "\t\t{\n";

		print "\t\t\t\"Filename\" : \"" . $stats{'filename'} . "\"\n";
		print "\t\t\t\"Path\" : \"" . $stats{'filepath'} . "\"\n";
		print "\t\t\t\"Type\" : \"" . $stats{'filetype'} . "\"\n";
		print "\t\t\t\"Tokens\" : [\n";
		
		foreach my $t (@tokens) {
			$count = $count + 1;
			print "\t\t\t\t\"Token\" : \"" . $count . "\",\n";
			print "\t\t\t\t\"Linenum\" : \"" . $t->{'line'} .
				"\",\n";
			print "\t\t\t\t\"Columnnum\" : \"" . $t->{'pos'} .
				"\",\n";
			print "\t\t\t\t\"Type\" : \"" . $t->{'type'} . "\",\n";
			if ($t->{'type'} eq "whitespace") {
				print "\t\t\t\t\"Value\" : \"" .
					print_whitespace($t->{'value'}) .
					"\",\n";
			} else {
				print "\t\t\t\t\"Value\" : \"" . $t->{'value'} .
					"\",\n";
			}
			print "\n";
		}
		print "\t\t\t\t},\n";
		print "\t\t\t]\n";
		print "\t\t},\n";
		print "\t]\n";
		print "}\n";

	} elsif ($outputtype eq "human") {
		print "\t\"ProjectName\" : \"" . $stats{'project_name'} . "\"\n";
		print "\t\"ProjectDescription\" : \"" .
			$stats{'project_description'} . "\"\n";
		print "\t\"Files\" : [\n";

		print "\t\t\"Filename\" : \"" . $stats{'filename'} . "\"\n";
		print "\t\t\"Path\" : \"" . $stats{'filepath'} . "\"\n";
		print "\t\t\"Type\" : \"" . $stats{'filetype'} . "\"\n";
		print "\t\t\"Tokens\" :\n";

		foreach my $t (@tokens) {
			$count = $count + 1;
			print "\t\t\t\"Token\" : \"" . $count . "\",\n";
			print "\t\t\t\"Linenum\" : \"" . $t->{'line'} .
				"\",\n";
			print "\t\t\t\"Columnnum\" : \"" . $t->{'pos'} .
				"\",\n";
			print "\t\t\t\"Type\" : \"" . $t->{'type'} . "\",\n";
			if ($t->{'type'} eq "whitespace") {
				print "\t\t\t\"Value\" : \"" .
					print_whitespace($t->{'value'}) .
					"\",\n";
			} else {
				print "\t\t\t\"Value\" : \"" . $t->{'value'} .
					"\",\n";
			}
			print "\n";
		}
	}

	print "Count: $count\n";
	return $count;
}

sub last_token {
	my ($param) = @_;

	return $tokens[-1]->{$param};
}

1;
