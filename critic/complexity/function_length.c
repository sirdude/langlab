#include <critic.h>

struct critmod;

int init() {
	critmod.name = "function_length";
	critmod.criticality = 4;
	critmod.package = "complexity";
	critmod.info = "Functions over 50 lines should be refactored into smaller chunks.";
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
