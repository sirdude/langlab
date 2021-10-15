#include <critic.h>

struct critmod;

int init() {
	critmod.name = "precidence";
	critmod.criticality = 4;
	critmod.package = "complexity";
	critmod.info = "If expressions have multiple operators without ()'s " +
		"to explicitly order the operators warn us.";
	critmod.good = "(x + 5) * 3";
	critmod.bad = "x + 5 * 3";
}

int violates (struct *node, struct *wholefile) {

	/* do check here XXX */
	if () {
		return 1;
	}

	return 0;
}
