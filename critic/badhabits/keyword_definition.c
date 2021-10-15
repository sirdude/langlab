#include <critic.h>

struct critmod;

int init() {
	critmod.name = "keyword_def";
	critmod.criticality = 3;
	critmod.package = "badhabit";
	critmod.info = "Function and variable names should not be keywords";
}

int violates (struct *node, struct *wholefile) {
	if ((node.type != "function") && (node.type != "variable")) {
		return 0;
	}

	/* do check here XXX */
	if () {
		return 1;
	}

	return 0;
}
