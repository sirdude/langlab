#include <critic.h>

struct critmod;

int init() {
	critmod.name = "var_space";
	critmod.criticality = 3;
	critmod.package = "structure";
	critmod.info = "Variables should be defined at the top of a code " +
		"block.  Following a variable declaration, there should " +
		"be more variable declarations, or a blank line.";
	critmod.good = "";
	critmod.bad = "";
}

int violates (struct *node, struct *wholefile) {
	if (node.type != var) {
		return 0;
	}

	/* do check here XXX */
	if () {
		return 1;
	}

	return 0;
}
