#include <critic.h>

struct critmod;

int init() {
	critmod.name = "while";
	critmod.criticality = 4;
	critmod.package = "complexity";
	critmod.info = "While statements should not contain complex code " +
		"in their, conditional check.";
	critmod.good = "while( x < 10) {";
	critmod.bad = "while ( x++ / 5 < somevalue * factor / 20) {";
}

int violates (struct *node, struct *wholefile) {
	if (node.type != while) {
		return 0;
	}

	/* do check here XXX */
	if () {
		return 1;
	}

	return 0;
}
