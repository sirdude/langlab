# package symbol_table;


object new() {
	object self = {};

	self['symtable'] = ();

	return self;
}

void clear(object self) {

	self['symtable'] = ();
}

# Simple symbol table functions
mixed lookup_value(object self, string var) {

	if (exists(self['symtable'][var])) {
		return self['symtable'][var]['value'];
	}

	return "";
}

string lookup_type(object self, string var) {

	if (exists(self['symtable'][var])) {
		return self['symtable'][var]['type'];
	}
	return '';
}

int intable(object self, string var) {

	if (exists(self['symtable'][var])) {
		$self['symtable'][var]['count'] = self['symtable'][var]['count'] + 1;
		return 1;
	}

	return 0;
}

int insert_symbol(object self, string sym, string type, mixed val) {
	object tmp;

#	debug('insert_symbol: Sym: ' . $sym . ' Type: ' .
#		$type . ' Val: ' . $val);

	if (intable(sym)) {
		error('Duplicate entry: ' + sym);
		return 0;
	}

	tmp['value'] = val;
	tmp['type'] = type;
	tmp['count'] = 1;
	self['symtable'][sym] = *tmp;

	return 1;
}

int dump_table(object self, string tmp, string val) {
	string i;

	print "Symbol Table Dump:\n";
	foreach i (keys self['symtable']) {
		tmp = self['symtable'][i];

		if (exists(tmp['value'])) {
			val = tmp['value'];
		} else {
			val = 'null';
		}

		if (tmp['type'] == 'keyword') {
			print '\tSymbol: ' + i + ': type: ' + tmp['type'] +
				" count: " + tmp['count'] + "\n";
		} else {
			print "\tSymbol: " + i + ': type: ' + tmp['type'] +
				' value: ' + val + ' count: ' + tmp['count'] +
				"\n";
		}
	}
	print "\n\n";

	return 1;
}

