#include <critic.h>

struct critmod;

int init() {
	critmod.name = "if";
	critmod.criticality = 4;
	critmod.package = "complexity";
	critmod.info = "If statements should not contain complex code in " +
		"their, conditional check.";
	critmod.good = "if ( x < 10) {";
	critmod.bad = "if ( x++ / 5 < somevalue * factor / 20) {";
}

int violates (struct *node, struct *wholefile) {
	if (node.type != if) {
		return 0;
	}

	/* do check here XXX */
	if () {
		return 1;
	}

	return 0;
}
