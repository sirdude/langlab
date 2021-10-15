#include <critic.h>

struct critmod;

int init() {
	critmod.name = "double_assignment";
	critmod.criticality = 3;
	critmod.package = "badhabit";
	critmod.info = "Do not use double assignments within a single " +
		"statement.";
	critmod.good = "k = 1;  t = 1;";
	critmod.bad = "k = t = 1;";
}

int violates (struct *node, struct *wholefile) {
	if ((node.type != "=")) {
		return 0;
	}

	/* do check here XXX */
	if () {
		return 1;
	}

	return 0;
}
