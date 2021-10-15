#include <critic.h>

struct critmod;

int init() {
	critmod.name = "ignore_function";
	critmod.criticality = 3;
	critmod.package = "structure";
	critmod.info = "Function return values should not be ignored.";
	critmod.good = "if(do_stuff()) { do_more_stuff() }";
	critmod.bad = "do_stuff(); do_more_stuff();";
}

int violates (struct *node, struct *wholefile) {
	if (node.type != function) {
		return 0;
	}

	/* do check here XXX */
	if () {
		return 1;
	}

	return 0;
}
