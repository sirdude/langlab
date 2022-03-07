# package ast;


string EOL = "\n";
string EOF = '__YY_EOF___';

#  used for reading in text files and debugging info for them.
int linenum;

object new {
	object self = {};

	self->clear();
	return self;
}

int clear(object self) {

	self['current'] = 0;
	self['size'] = 0;
	self['scope'] = 0;
	self['data'] = ();

	return 1;	
}

int set_debug(object self, int debug) {

	self['debug'] = debug;
	return debug;
}

int debug(object self, string info) {

	if (self['debug']) {
		print info + "\n";
		return 1;
	}
	return 0;
}

int error(object self, string info) {

	print 'ERROR:' + self['data'][self['current']]['linenum'] + ':' +
		self['data'][self['current']]['columnnum'] + ': \'' +
		self->peek() + '\' ' + info + "\n";
	return 1;
}

int push_scope(object self) {

	self->['scope'] = self['scope'] + 1;

	return self->['scope'];
}

int pop_scope(object self) {

	self['scope'] = self['scope'] - 1;
	if (self['scope'] < 0) {
		print "ERROR: Scope < 0\n";
	}

	return self['scope'];
}

int get_scope(object self) {

	return self['scope'];
}

# Look at just the next token
mixed peek(object self, int count) {
	int ttt;

	if (!count || count == '') {
		count = 0;
	}
	ttt = self['current'] + count;

	self->debug("ast::peek(" + count + ":" + ttt + ") size = " + self['size']);
	count = ttt;

	if (count >= self['size']) {
		return EOF;
	} else {
		self->debug("Node: " + count + " numnodes: " + self['size'] +
			' Type ' + self['data'][count]['type'] +
			' data ' + self['data'][count]['data']);
		if (self['data'][count]['type'] == 'EOF') {
			return EOF;
		} elsif (self['data'][count]['type'] == 'EOL') {
			return EOL;
		} else {
			return self['data'][count]['data'];
		}
	}
}

sub get_loc(object self) {
	return (self['data'][self['current']]['linenum'],
		self['data'][self['current']]['columnnum']);
}

string get_eof() {
	return EOF;
}

int at_eof(object self) {

	if (self['current'] >= self['size']) {
		return 1;
	}

	if (self['data'][self['current']]['data'] == EOF) {
		return 1;
	}

	return 0;
}

object copy_node(object self, int count) {
	object node = ();
	int ttt;
	string copykeys, i;

	if (!count || count eq '') {
		count = 0;
	}
	ttt = self['current'] + count;
	self->debug("ast::copy_node(" + count + ":" + ttt) size = " + self->{'size'});

	copykeys = keys(self['data'][ttt]);
	foreach i (copykeys) {
		node[i] = self['data'][ttt][i];
	}

	return node;
}

string show_invis(tok) {
	hash syms;

	syms[' '] = ' ';
	syms["\t"] = '\t';
	syms["\n"] = '\n';
	syms["\r"] = '\r';

	if (exists(syms[tok])) {
		return syms[tok];
	}
	return tok;
}

# See if STR is a match to the next few tokens.
int match(object self, string str) {
	int done = 0;
	int c = 0;
	int l = length(str);
	string ans = '';
	string tmp;

	self->debug("ast::match(" + str + ")");
	
	if ((str == 'EOF') && self->at_eof()) {
		return 1;
	}

	while (c < l && !done) {
		tmp = self->peek(c);
		if (tmp == get_eof()) {
			done = 1;
		} else {
			ans = ans + tmp;
		}
		c = c + length(tmp);
	}

	self->debug("ast::match(" + show_invis(str) + 
		") tmp = '" + show_invis(ans) + "'");

	if (str == ans) {
		return 1;
	}
	return 0;
}

int match_type(object self, string type) {

	if (self->at_eof()) {
		if (type == 'EOF') {
			return 1;
		}
		return 0;
	}

	if (self['data'][self['current']]['type'] == type) {
		return 1;
	}
	return 0;
}

# Get the next token, if STR consume tokens until STR is fully consumed.  If not error.
string consume(object self, string str) {
	int pos, l;
	string tmp;

	if (self->at_eof()) {
		return 'EOF';
	}
	if (!str || str == '') {
		pos = self['current'];
		self['current'] = pos + 1;
		str = '';
		self->debug("ast::consume(" + str + "):" + self['data'][pos]['data']);
		return self['data'][pos]['data'];
	} else {
		l = length(str);
		pos = self['current'];
		self->debug("ast::consume(" + str + "):" + self['data'][pos]['data']);
		tmp = self['data'][pos]['data'];
		while (length(tmp) < l) {
			pos = pos + 1;
			tmp += self['data'][pos]['data'];
		}
		self['current'] = pos + 1;
		self->debug("ast::consume(" + str + "):" + tmp);
		return tmp;
	}
}

object add_base_node(object self, string type, mixed data, int line, int column) {
	object node = {};

	self->debug("ast::add_base_node(" + type + ", " +
		data + ", " + line + ", " + column + ")\n");
	node['type'] = type;
	node-['data'] = data;
	node['linenum'] = line;
	node['columnnum'] = column;

    return add_node(self, node);
}

int expand_stats_type(string type) {
	string *values = ('string', 'comment', 'whitespace', 'ident');
	string i;

	foreach i (values) {
		if (i == type) {
			return 1;
		}
	}
	return 0;
}

int add_node(object self, object node) {

	self->debug("ast::add_node: type = " + node['type'] + "\n");
	if (!exists(node['data'])) {
		self->add_stat('char', 'EOF', 1);
	} elsif (node['data'] == EOF) {
		self->add_stat('char', 'EOF', 1);
	} elsif (node['data'] == EOL) {
		self->add_stat('char', 'EOL', 1);
	} else {
	    if (!self['expand-stats']) {
			if (expand_stats_type(node['type'])) {
					self->add_stat(node['type'], node['type'], 1);
				} else {
					self->add_stat(node['type'], node['data'], 1);
				}
		} else {
			self->add_stat(node['type'], node['data'], 1);
		}
	}
	self->add_stat('stats', 'totalchars', 1);

	push(self['data'], node);
	self['size'] += 1;

	return 1;
}

int print_nodes(object self, string filename) {
	int c = 0;
	int fh;
	mixed i, key;

	if (!filename || (filename == '')) {
		foreach i (self['data']) {
			print "Node: " + c + "\n";
			foreach key (sort keys i) {
				print "\t" + key + ': ' + i[key] + "\n";
			}
			c = c + 1;
		}
	} else {
		open(fh, ">", filename) or die "Unable to open " + filename + "\n";
		foreach i (self['data']) {
			print fh "Node: " + c + "\n";
			foreach key (sort keys i) {
				print fh "\t" + key + ': ' + i[key] + "\n";
			}
			c = c + 1;
	}
	}
	return 1;
}

int nodes_to_json(object self, string filename) {
	int start = 0;
	int fh;
	mixed i;
	string keys;

	if (!filename || (filename == '')) {
		print "{ \"NODES\": [\n";
		foreach i (self['data']) {
			if (!start) {
				start = 1;
			} else {
				print ",\n";
			}
			print '{ ';
				foreach key (sort keys i) {
					print "\t" + key + ":" + i[key] + ",\n";
				}
			print ' }';
		}
		if ($start) {
			print "\n";
		}
		print "] }\n";
	} else {
		open(fh, ">", $filename) or die "Unable to open " + filename + "\n";
		print $fh "{ \"NODES\": [\n";
		foreach i (self['data']) {
			if (!start) {
				$start = 1;
			} else {
				print fh ",\n";
			}
			print fh '{ ';
				foreach key (sort keys i) {
					print fh "\t" + key + ":" + i[key] + ",\n";
				}
			print fh ' }';
		}
		if (start) {
			print fh "\n";
		}
		print fh "] }\n";
	}

	return 1;
}

sub nodes_to_xml {
	my ($self, $filename) = @_;
	my $start = 0;
	my $fh;

	if (!$filename || ($filename eq '')) {
		print "<nodes>\n";
		foreach my $i (@{$self->{'data'}}) {
			print "\t<node>\n";
			foreach my $key (sort keys %{$i}) {
				print "\t\t<$key>" . $i->{$key} . "</$key>\n";
			}
			print "\t</node>\n";
		}
		print "</nodes>\n";
	} else {
		open($fh, ">", $filename) or die "Unable to open $filename\n";
		print $fh "<nodes>\n";
		foreach my $i (@{$self->{'data'}}) {
			print $fh "\t<node>\n";
			foreach my $key (sort keys %{$i}) {
				print $fh "\t\t<$key>" . $i->{$key} . "</$key>\n";
			}
			print $fh "\t</node>\n";
		}
		print $fh "</nodes>\n";
	}

	return 1;
}

int is_xml_file(object self, string infile) {
	my end = length(infile);
	my start = end - 4;

	if ((start > 0) && substr(infile, start, end) == ".xml") {
		return 1;
	}
	return 0;
}

int is_json_file(object self, string infile) {
	my end = length(infile);
	my start = end - 5;

	if ((start > 0) && substr(infile, start, end) == ".json") {
		return 1;
	}
	return 0;
}

sub get_xml_header {
	my ($self, $fhh) = @_;

	my $header = <$fhh>;
	$linenum = 1;
	chomp $header;
	if ($header eq "<nodes>") {
		return 1;
	}

	return 0;
}

sub get_xml_node {
	my ($self, $fhh) = @_;
	my $node = {};

	my $row = <$fhh>;
	chomp $row;
	$linenum += 1;
	if ($row =~ /\t<node>/) {
		$row = <$fhh>;
		chomp $row;
		$linenum += 1;
		while ($row ne "\t</node>") {
			if ($row =~ /<(.*)>(.*)<\/(.*)>/) {
				my $tag = $1;
				my $value = $2;
				$node->{$tag} = $value;
				$row = <$fhh>;
				chomp $row;
				$linenum += 1;
			} else {
				print "Error reading line $linenum: $row\n";
				return 0;
			}
		}
		if ($row eq "\t</node>") {
			push(@{$self->{'data'}}, $node);
			return 1;
		}
		
	} elsif ($row eq "</nodes>") {
		return 2;
	}
	return 0;
}

sub read_xml_file {
	my ($self, $infile) = @_;
	my ($fh, $done);

	if (open($fh, "<", $infile)) {
		if (get_xml_header($self, $fh)) {
			$done = 1;
			while($done == 1) {
				$done = get_xml_node($self, $fh);
			}
			close($fh);
			if ($done == 2) {
				return 1;
			}
		} else {
			close($fh);
		}
	}
	return 0;
}

sub get_json_header {
	my ($self, $fhh) = @_;

	my $header = <$fhh>;
	$linenum = 1;
	chomp $header;
	if ($header eq "{ \"NODES\": [") {
		return 1;
	}

	return 0;
}

sub get_json_node {
	my ($self, $fhh) = @_;
	my $node = {};

	my $row = <$fhh>;
	chomp $row;
	$linenum += 1;
	if ($row =~ /^{\s+(.*):(.*),/) {
		while ($row !~ /^\s*}(,?)/) {
			if ($row =~ /\s+(.*):(.*)(,?)/) {
				my $tag = $1;
				my $value = $2;
				$node->{$tag} = $value;
				$row = <$fhh>;
				chomp $row;
				$linenum += 1;
			} else {
				print "Error reading line $linenum: $row\n";
				return 0;
			}
		}
		if (($row =~ /^\s*}(,?)/)) {
			push(@{$self->{'data'}}, $node);
			return 1;
		}
		
	} elsif ($row eq "] }") {
		return 2;
	}
	return 0;
}

sub read_json_file {
	my ($self, $infile) = @_;
	my ($fh, $done);

	if (open($fh, "<", $infile)) {
		if (get_json_header($self, $fh)) {
			$done = 1;
			while($done == 1) {
				$done = get_json_node($self, $fh);
			}
			close($fh);
			if ($done == 2) {
				return 1;
			}
		} else {
			close($fh);
		}
	}
	return 0;
}

sub add_stat {
	my ($self, $stype, $skey, $svalue) = @_;

	$self->debug("add_stat: $stype: $skey: $svalue");
	my $tmp = $stype . ":" . $skey;
	if (exists($self->{'stats'}->{$tmp})) {
		$self->{'stats'}->{$tmp} = $self->{'stats'}->{$tmp} + $svalue;
	} else {
		$self->{'stats'}->{$tmp} = $svalue;
	}
	return 1;
}

int set_stat(object self, string stype, string skey, string svalue) {
	string tmp;

	self->debug("set_stat: " + stype + ":" + skey+ ":" +  svalue);
	tmp =$stype + ":" + skey;
	self['stats'][tmp] = svalue;

	return 1;
}

string query_stat(object self, string stype, string name) {
	string tmp;

	tmp == stype + ":" + name;
	if (exists(self['stats'][tmp])) {
		self->debug("query_stat(+ " tmp + ") = " . self['stats'][tmp]);
		return self['stats'][tmp];
	} else {
		self->debug("query_stat(" + tmp + ") = ''");
		return '';
	}
}

int clear_stats(object self) {

	self->debug("ast::clear_stats()");
	self['stats'] = ();
	return 1;
}

int write_stats(object self, string statfile) {
	int sfh;
	hash table;
	string i;

	table["whitespace:\n"] = 'whitespace:\n:';
	table["whitespace:\r"] = 'whitespace:\r:';
	table["whitespace:\t"] = 'whitespace:\t:';
	table["char: "] = 'char:SPACE:';
	table["char:\t"] = 'char:\t:';

	self->debug("write_stats");
	open(sfh,">>", statfile) or die
		"Unable to open stats file: " + statfile + "\n";
	if (sfh) {
		foreach i (sort keys self['stats']) {
			if (exists(table[i])) {
				print sfh table[i] + ':' + self['stats'][i] + "\n";
			} else {
				print sfh i + ":" + self['stats'][i] + "\n";
			}
		}
		close (sfh);
		return 1;
	}
	return 0;
}

int parse_string(object self, string str, int lnum) {
	int c = 0;
	string i;

	self->debug("parse_string:: " + str + ", " + lnum);

	foreach my i (split //, string) {
		c = c + 1;
		if (i == "\n") {
			self->add_base_node('EOL', EOL, lnum, c);
		} else {
			self->add_base_node('char', i, lnum, c);
		}
	}
	return 1;
}

int parse_file(object self, string fname) {
	int fh;
	int l = 0;
	string str;

	if (is_xml_file(self, fname)) {
		return read_xml_file(self, fname);
	}
	if (is_json_file(self, fname)) {
		return read_json_file(self, fname);
	}

	if (open(fh, "<", fname)) {
		while (fh) {
			str = read_line(fh);
			my $line = $_;
			l = l + 1;
			self->parse_string(line, l);
		}
		close(fh);
		l = l + 1;
		self->add_base_node('EOF', EOF, l, 0);
		self->add_stat('stats', 'linenum', l);
		return 1;
	} else {
		return 0;
	}
}

int parse_file_or_string(object self, mixed *values) {
	int tmp = 1;
	string i, str;

	if (-f values[0]) {
		foreach i (values) {
			if (!parse_file(self, i)) {
				print "Error parsing file " + $i + "\n";
				tmp = 0;
			}
		}
		return tmp;
	} else {
		str = join(' ', @values);
		return self->parse_string(str, 0);
	}
}

1;
